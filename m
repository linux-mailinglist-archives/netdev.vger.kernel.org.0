Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5706267C092
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 00:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbjAYXFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 18:05:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbjAYXFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 18:05:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6762BEEE
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 15:05:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC9F961647
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:05:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF18DC433EF;
        Wed, 25 Jan 2023 23:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674687921;
        bh=yHsI55fhDKoe+v4ZD8BdMU4MpPGTJuLZzVx4TpVaEp8=;
        h=From:To:Cc:Subject:Date:From;
        b=JOMzRiaFMxdj7P0pos99zeXTvYUvJxz+C0utjxIQMN9/nlCQinbSQBD/f7LdHV1ZG
         5exETnxshCpl6PhID8FTizGhbgThySbqByCkjwwLDjDBWf8Yn4x0pOqsLR01ewDT9t
         tCIm0dvI8u+I+n17qBe8d+12MMOe8jnShJAy99oYnXINmFnRDomAp9WCnoYLJlLnEv
         36fIpHVcS6wUH5wc1vN9xhEXUs9DGf0Bs79qqyaU8J2tM7O3CGSdvbwXMZEqnRSpQ0
         x1YEGGWBDPvnx1TkiXGCZg+9eEr8pvOmXE63ACsyYOlw4mziBZ9P+HEUmGNn4c2LZ5
         K5uIZXlRAK+1Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 0/2] ethtool: netlink: handle SET intro/outro in the common code
Date:   Wed, 25 Jan 2023 15:05:17 -0800
Message-Id: <20230125230519.1069676-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Factor out the boilerplate code from SET handlers to common code.

I volunteered to refactor the extack in GET in a conversation
with Vladimir but I gave up.

The handling of failures during dump in GET handlers is a bit
unclear to me. Some code uses presence of info as indication
of dump and tries to avoid reporting errors altogether
(including extack messages).

There's also the question of whether we should have a validation
callback (similar to .set_validate here) for GET. It looks like
.parse_request was expected to perform the validation. It takes
the extack and tb directly, not via info:

	int (*parse_request)(struct ethnl_req_info *req_info,
			     struct nlattr **tb,
			     struct netlink_ext_ack *extack);

	int (*prepare_data)(const struct ethnl_req_info *req_info,
			    struct ethnl_reply_data *reply_data,
			    struct genl_info *info);

so no crashes dereferencing info possible.

But .parse_request doesn't run under rtnl nor ethnl_ops_begin().
As a result some implementations defer validation until .prepare_data
where all the locks are held and they can call out to the driver.

All this makes me think that maybe we should refactor GET in the
same direction I'm refactoring SET. Split .prepare_data, take
more locks in the core, and add a validation helper which would
take extack directly:

    - ret = ops->prepare_data(req_info, reply_data, info);
    + ret = ops->prepare_data_validate(req_info, reply_data, attrs, extack);
    + if (ret < 1) // if 0 -> skip for dump; -EOPNOTSUPP in do
    +   goto err1;
    +
    + ret = ethnl_ops_begin(dev);
    + if (ret)
    +   goto err1;
    +
    + ret = ops->prepare_data(req_info, reply_data); // no extack
    + ethnl_ops_complete(dev);

I'll file that away as a TODO for posterity / older me.

v2:
 - invert checks for coalescing to avoid error code changes
 - rebase and convert MM as well

v1: https://lore.kernel.org/all/20230121054430.642280-1-kuba@kernel.org/

Jakub Kicinski (2):
  ethtool: netlink: handle SET intro/outro in the common code
  ethtool: netlink: convert commands to common SET

 net/ethtool/channels.c  |  92 ++++++++++++++----------------------
 net/ethtool/coalesce.c  |  92 ++++++++++++++++--------------------
 net/ethtool/debug.c     |  71 ++++++++++++----------------
 net/ethtool/eee.c       |  78 ++++++++++++-------------------
 net/ethtool/fec.c       |  83 +++++++++++++--------------------
 net/ethtool/linkinfo.c  |  81 ++++++++++++++------------------
 net/ethtool/linkmodes.c |  91 +++++++++++++++++-------------------
 net/ethtool/mm.c        |  82 ++++++++++++--------------------
 net/ethtool/module.c    |  89 ++++++++++++++---------------------
 net/ethtool/netlink.c   |  91 ++++++++++++++++++++++++++++++------
 net/ethtool/netlink.h   |  36 +++++++-------
 net/ethtool/pause.c     |  79 +++++++++++++------------------
 net/ethtool/plca.c      |  75 +++++++++--------------------
 net/ethtool/privflags.c |  84 ++++++++++++++++-----------------
 net/ethtool/pse-pd.c    |  79 ++++++++++++-------------------
 net/ethtool/rings.c     | 101 +++++++++++++++++-----------------------
 net/ethtool/wol.c       |  79 +++++++++++++------------------
 17 files changed, 608 insertions(+), 775 deletions(-)

-- 
2.39.1

