Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9792F62D25C
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 05:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234505AbiKQEfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 23:35:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbiKQEfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 23:35:33 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A4B5EFAD
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 20:35:31 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id t1so503026wmi.4
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 20:35:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HBvVgCUyyrG5e1srJyYhoxydOMdPiZt9cegr+mZ1TSU=;
        b=O3aq4+7dTTJHYYJxTdcCYLTq/UzEMC4QhOtuxQCqU2MC1sexu9+89xqReo7PWnCizV
         m28pkpyOjC22GE69d+xnutjsLMM4/lfspi8MqdD/u0cpjOzxCrzB++HMsxCmWtxkhOIC
         gNx5CCW6fNnLujbHGTrxufzihL00260ltxVuY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HBvVgCUyyrG5e1srJyYhoxydOMdPiZt9cegr+mZ1TSU=;
        b=sjWkwn80S+i4WMT8t8UU3IA3KUC57ilq54wcdH8Wox4C7o0B0FRvwZhYxvP0gsTzye
         0xcWTFFn1+tAvs7o/gE1L13NeBQwMWk/pGjIeaQFWDcMJaN68oJTS3dC/1I03yhFvFCe
         Hlo6Jq/QSwvM4yN8Tp0kH2KE41XKsDh3X34/WG+EOFzLy4jYr2SF8NAj+wZudedePEaO
         zzlBF4KTUvs5aDjPfow3Yswpb+HuFE20PrKy3D5t0GZAc7JL42XY1soHQLjV2lCnh/8L
         zdFDWoDBby41qShA1SosYnpiFX8yLHYB8vhqJN3CICNOKfavPzMEh+p73ttj/CkQ3vmC
         CgMw==
X-Gm-Message-State: ANoB5pnmbw0Ikml6aiuoKti3HfkE5Tn94aaSQ78+uCXw40BxPqh/1kTu
        a4Pw3W5Ea+jyHLFkALoZFpO6wEC1HPE0g5r1yiAd6ZHihWI=
X-Google-Smtp-Source: AA0mqf4M07HKY/MtFOwGFzaRigxLTCasj48L05DupbPWVtLxrsSoK3Y5drIIoqL8QJxrH3C+4einZ6qxk/SJXeZfCrc=
X-Received: by 2002:a05:600c:3495:b0:3cf:a258:99b with SMTP id
 a21-20020a05600c349500b003cfa258099bmr434851wmq.34.1668659729528; Wed, 16 Nov
 2022 20:35:29 -0800 (PST)
MIME-Version: 1.0
From:   Joel Stanley <joel@jms.id.au>
Date:   Thu, 17 Nov 2022 04:35:17 +0000
Message-ID: <CACPK8Xdfi=OJKP0x0D1w87fQeFZ4A2DP2qzGCRcuVbpU-9=4sQ@mail.gmail.com>
Subject: warn in ncsi netlink code
To:     Networking <netdev@vger.kernel.org>,
        Sam Mendoza-Jonas <sam@mendozajonas.com>
Cc:     Kees Cook <keescook@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

next-20221114 running on an ast2600 system produced this:

[   44.627332] ------------[ cut here ]------------
[   44.632657] WARNING: CPU: 0 PID: 508 at net/ncsi/ncsi-cmd.c:231
ncsi_cmd_handler_oem+0xbc/0xd0
[   44.642387] memcpy: detected field-spanning write (size 7) of
single field "&cmd->mfr_id" at net/ncsi/ncsi-cmd.c:231 (size 4)
[   44.655131] CPU: 0 PID: 508 Comm: ncsi-netlink Not tainted
6.1.0-rc5-14066-gefbdad8553d8 #17
[   44.664577] Hardware name: Generic DT based system
[   44.664599]  unwind_backtrace from show_stack+0x18/0x1c
[   44.675801]  show_stack from dump_stack_lvl+0x40/0x4c
[   44.681458]  dump_stack_lvl from __warn+0xb8/0x12c
[   44.686814]  __warn from warn_slowpath_fmt+0x9c/0xd8
[   44.692370]  warn_slowpath_fmt from ncsi_cmd_handler_oem+0xbc/0xd0
[   44.699285]  ncsi_cmd_handler_oem from ncsi_xmit_cmd+0x160/0x29c
[   44.706002]  ncsi_xmit_cmd from ncsi_send_cmd_nl+0x13c/0x1dc
[   44.712337]  ncsi_send_cmd_nl from genl_rcv_msg+0x1d0/0x440
[   44.718579]  genl_rcv_msg from netlink_rcv_skb+0xc0/0x120
[   44.724623]  netlink_rcv_skb from genl_rcv+0x28/0x3c
[   44.730182]  genl_rcv from netlink_unicast+0x208/0x370
[   44.735934]  netlink_unicast from netlink_sendmsg+0x1e4/0x450
[   44.742365]  netlink_sendmsg from ____sys_sendmsg+0x23c/0x2b8
[   44.748799]  ____sys_sendmsg from ___sys_sendmsg+0x9c/0xd0
[   44.754941]  ___sys_sendmsg from sys_sendmsg+0x78/0xbc
[   44.760695]  sys_sendmsg from ret_fast_syscall+0x0/0x54
[   44.766544] Exception stack(0xb57b1fa8 to 0xb57b1ff0)
[   44.772191] 1fa0:                   0244f330 0244f1e0 00000003
7ee36a60 00000000 00000000
[   44.781328] 1fc0: 0244f330 0244f1e0 76f35c60 00000128 76f91550
0244f387 0244f387 00498e7c
[   44.790462] 1fe0: 76f35d34 7ee36a10 76f1b510 76bba140
[   44.796186] ---[ end trace 0000000000000000 ]---

The relevant code:

static int ncsi_cmd_handler_oem(struct sk_buff *skb,
                                struct ncsi_cmd_arg *nca)
{
        struct ncsi_cmd_oem_pkt *cmd;
        unsigned int len;
        int payload;
        /* NC-SI spec DSP_0222_1.2.0, section 8.2.2.2
         * requires payload to be padded with 0 to
         * 32-bit boundary before the checksum field.
         * Ensure the padding bytes are accounted for in
         * skb allocation
         */

        payload = ALIGN(nca->payload, 4);
        len = sizeof(struct ncsi_cmd_pkt_hdr) + 4;
        len += max(payload, padding_bytes);

        cmd = skb_put_zero(skb, len);
        memcpy(&cmd->mfr_id, nca->data, nca->payload);
        ncsi_cmd_build_header(&cmd->cmd.common, nca);

        return 0;
}

I think it's copying the command payload to the command packet,
starting at the offset of mfr_id:

struct ncsi_cmd_oem_pkt {
        struct ncsi_cmd_pkt_hdr cmd;         /* Command header    */
        __be32                  mfr_id;      /* Manufacture ID    */
        unsigned char           data[];      /* OEM Payload Data  */
};

But I'm not too sure.

Cheers,

Joel
