Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE71A4B6D09
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 14:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237992AbiBONIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 08:08:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235971AbiBONIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 08:08:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B486EC0853;
        Tue, 15 Feb 2022 05:08:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44ABB61702;
        Tue, 15 Feb 2022 13:08:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB5F4C340EB;
        Tue, 15 Feb 2022 13:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644930516;
        bh=PoalmMqaKc50oi1r+URZvae0kyLA/F8Qd8LE+/pth4A=;
        h=From:To:Cc:Subject:Date:From;
        b=ixQMXt3i2vm3vL3QnsZHWmpC7IHLiztayu75L6ENwQ4SbvOl2kEB3xbTJ+kmIqZn9
         MF+r885IjLlcrAPgzuqgGD+HytsMZmcJ61SBia6KW1m035bnpJcgLt/vdLjVwYCIBw
         PNBuA59scesqySQvldesPivEyQNDQv71AVGNkPe9XOSXgR8ZQ3A60gTfepMa3jy+Ia
         YLdUMqcEwwGHnZivKaqU7AgsOoDlRBl5PPxkpivuCCi2srocLv9w0YDCIvfMMeBjbO
         gjMB53MMn4LwJVxqElb2SH4E8IO86ZkDkyABHKZ0sCrJ7zw7diH0DjduoA5+KvL+8+
         j7y3IFQSayd4g==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com, toke@redhat.com,
        pabeni@redhat.com, echaudro@redhat.com,
        lorenzo.bianconi@redhat.com, toshiaki.makita1@gmail.com,
        andrii@kernel.org
Subject: [PATCH v2 bpf-next 0/3] introduce xdp frags support to veth driver
Date:   Tue, 15 Feb 2022 14:08:08 +0100
Message-Id: <cover.1644930124.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce xdp frags support to veth driver in order to allow increasing the mtu
over the page boundary if the attached xdp program declares to support xdp
fragments. Enable NETIF_F_ALL_TSO when the device is running in xdp mode.
This series has been tested running xdp_router_ipv4 sample available in the
kernel tree redirecting tcp traffic from veth pair into the mvneta driver.

Changes since v1:
- always consider skb paged are non-writable
- fix tpt issue with sctp
- always use napi if we are running in xdp mode in veth_xmit

Lorenzo Bianconi (3):
  net: veth: account total xdp_frame len running ndo_xdp_xmit
  veth: rework veth_xdp_rcv_skb in order to accept non-linear skb
  veth: allow jumbo frames in xdp mode

 drivers/net/veth.c | 204 +++++++++++++++++++++++++++++----------------
 include/net/xdp.h  |  14 ++++
 net/core/xdp.c     |   1 +
 3 files changed, 146 insertions(+), 73 deletions(-)

-- 
2.35.1

