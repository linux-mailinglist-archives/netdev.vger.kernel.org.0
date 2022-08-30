Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B82BE5A662B
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 16:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbiH3OXo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 30 Aug 2022 10:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbiH3OXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 10:23:40 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76146B9FBD
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 07:23:37 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-328-VzN-35NXP96SHj1s8X62LA-1; Tue, 30 Aug 2022 10:23:34 -0400
X-MC-Unique: VzN-35NXP96SHj1s8X62LA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E69DB380450A;
        Tue, 30 Aug 2022 14:23:33 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.195.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA7D540C141D;
        Tue, 30 Aug 2022 14:23:32 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 0/6] xfrm: start adding netlink extack support
Date:   Tue, 30 Aug 2022 16:23:06 +0200
Message-Id: <cover.1661162395.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XFRM states and policies are complex objects, and there are many
reasons why the kernel can reject userspace's request to create
one. This series makes it a bit clearer by providing extended ack
messages for policy creation.

A few other operations that reuse the same helper functions are also
getting partial extack support in this series. More patches will
follow to complete extack support, in particular for state creation.

Note: The policy->share attribute seems to be entirely ignored in the
kernel outside of checking its value in verify_newpolicy_info(). There
are some (very) old comments in copy_from_user_policy and
copy_to_user_policy suggesting that it should at least be copied
to/from userspace. I don't know what it was intended for.

Sabrina Dubroca (6):
  xfrm: propagate extack to all netlink doit handlers
  xfrm: add extack support to verify_newpolicy_info
  xfrm: add extack to verify_policy_dir
  xfrm: add extack to verify_policy_type
  xfrm: add extack to validate_tmpl
  xfrm: add extack to verify_sec_ctx_len

 net/xfrm/xfrm_user.c | 163 +++++++++++++++++++++++++++----------------
 1 file changed, 103 insertions(+), 60 deletions(-)

-- 
2.37.2

