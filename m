Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA0057E5BE
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 19:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235591AbiGVRkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 13:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236149AbiGVRkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 13:40:15 -0400
X-Greylist: delayed 138 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 22 Jul 2022 10:40:12 PDT
Received: from smtpout30.security-mail.net (smtpout30.security-mail.net [85.31.212.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3225ADFDB
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 10:40:11 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by fx306.security-mail.net (Postfix) with ESMTP id A78D93994C1
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 19:37:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kalray.eu;
        s=sec-sig-email; t=1658511471;
        bh=6I/FMjMRm5/+ziJ3f2MtasSHKwp7VT5UJ7Q4lMxHURc=;
        h=Date:From:To:Cc:Subject;
        b=VJcz02YDnfcM0IbmtF1kU8Rxi3pIj7fiJTZghJKF3v5AaUw+oXuSDL81RvI9J35Of
         RAYECRrnh3XNfyRBteZlPLdnJev0nc4F85y8ZBeCwwTyIgupqa2GlVO/9+okzhSnHT
         EEjzPWKO9K2sFeTyOg6J8r73zxIo36hE3xwJQThg=
Received: from fx306 (localhost [127.0.0.1]) by fx306.security-mail.net
 (Postfix) with ESMTP id 4E83239948D; Fri, 22 Jul 2022 19:37:48 +0200 (CEST)
Received: from zimbra2.kalray.eu (unknown [217.181.231.53]) by
 fx306.security-mail.net (Postfix) with ESMTPS id AF7643993E0; Fri, 22 Jul
 2022 19:37:47 +0200 (CEST)
Received: from zimbra2.kalray.eu (localhost [127.0.0.1]) by
 zimbra2.kalray.eu (Postfix) with ESMTPS id 5A34F27E051A; Fri, 22 Jul 2022
 19:37:47 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1]) by zimbra2.kalray.eu
 (Postfix) with ESMTP id 4047627E051C; Fri, 22 Jul 2022 19:37:47 +0200 (CEST)
Received: from zimbra2.kalray.eu ([127.0.0.1]) by localhost
 (zimbra2.kalray.eu [127.0.0.1]) (amavisd-new, port 10026) with ESMTP id
 beAcCkG3J2w2; Fri, 22 Jul 2022 19:37:47 +0200 (CEST)
Received: from tellis.lin.mbt.kalray.eu (unknown [192.168.36.206]) by
 zimbra2.kalray.eu (Postfix) with ESMTPSA id 210CA27E051A; Fri, 22 Jul 2022
 19:37:47 +0200 (CEST)
X-Virus-Scanned: E-securemail, by Secumail
Secumail-id: <86.62dae06b.77eb3.0>
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra2.kalray.eu 4047627E051C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kalray.eu;
 s=32AE1B44-9502-11E5-BA35-3734643DEF29; t=1658511467;
 bh=1Nj9ZJdn2bYdZmwuaO6h1BTlzINee5SAkK8q3S1eqDY=;
 h=Date:From:To:Message-ID:MIME-Version;
 b=U0uDZdCSAlAoXaRcroXSMc5JrejMsWNZ8VvsPXWLg+Fdjchp2+ckBXpBP3fWbOzGQ
 eQz0gf+WyDVKzjh1ikHCvsyjOaBjRYXAlqnWFunBCa8MhUrlS3JU7GcK/K7PLqfQNO
 8ZuV6IFgpmV8L/u+OQCDOQI0neJ7XPtTd8txxXPs=
Date:   Fri, 22 Jul 2022 19:37:46 +0200
From:   Jules Maselbas <jmaselbas@kalray.eu>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: ethtool generate a buffer overflow in strlen
Message-ID: <20220722173745.GB13990@tellis.lin.mbt.kalray.eu>
MIME-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-ALTERMIMEV2_out: done
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I've come across this following image of a kernel BUG stack strace:
https://twitter.com/minut_e/status/1550139692615667715/photo/1

here is an ocr of the image above:
root@reform:~# ethtool -S enp0s0f0
[473.215343] detected buffer overflow in strlen
[473.219873] ------------[ cut here ]------------
[473.224502] kernel BUG at lib/string.c:1149!
[473.228785] Internal error: Oops - BUG: @ [#1] PREEMPT SMP
[473.234288] Modules linked in:
[473.237350] CPU: 1 PID: 1348 Comm: ethtool Not tainted 5.13.0-rc1+ #37
[473.243900] Hardware name: MNT Reform 2 with LS1028A (DT)
[473.249313] pstate: 6000005 (nZCv daif -PAN -UAO -TCO BTYPE=--)
[473.255339] pc : fortify_panic+0x20/0x24
[473.259281] Ir : fortify_panic+0x20/0x24
[473.263214] sp : ffffffc01093bb20
[473.266534] x29: ffffffc01093bb20 x28: ffffffa001591f00 x27: 0000000000000000
[473.273699] x26: 0000000000000000 x25: ffffffa0020fe840 x24: 0000000000000002
[473.280863] x23: ffffffe9f5b66408 x22: ffffffe9f5b671e4 x21: ffffffe9f5b66bd8
[473.288027] x20: 0000000000000020 x19: ffffffc0100b0a60 x18: 0000000000000000
[473.295189] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000030
[473.302353] x14: ffffffffffffffff x13: ffffffc09093b817 x12: ffffffc01093b81f
[473.309515] x11: ffffffe9f6815850 x10: eeaeaeaeFFTFTeG x9 : ffffffe9f4920c50
[473.316679] x8 : ffffffe9f67bd850 x7 : ffffffe9f6815850 x6 : 0000000000000000
[473.323841] x5 : 0000000000000000 x4 : ffffffal7efb79a0 x3 : 0000000000000000
[473.331003] x2 : 0000000000000000 x1 : ffffffade1591fe0 xe : 0000000000000022
[473.338166] Call trace:
[473.340614]  fortify_panic+0x20/0x24
[473.344198]  enetc_get_ethtool_stats+8x0/0x21c
[473.348656]  ethtool_get_strings+0x360/0x394
[473.352939]  dev_ethtool+0x1194/0x212c
[473.356696]  dev_ioctl+0x4f4/8x5f0
[473.360107]  sock_do_ioctl+8x104/0x280
[473.363868]  sock_ioctl+0x294/0x484
[473.367364]  __arm64_sys_ioctl+0xb4/0x100
[473.371386]  invoke_syscall+0x50/0x120
[473.375146]  e10_svc_common.constprop.0+0x4c/0xd4
[473.379865]  do_e10_svc+0x30/0x9c
[473.383188]  e10_svc+0x2c/0x54
[473.386248]  e10_sync_handler+0x1a4/0x1bd
[473.390266]  e10_sync+0x198/0x1c8
[473.393590] Code: aa0003e1 912b4040 910003fd 97fff04b (d4218000)
[473.399702] ---[ end trace e4d82f308db974e2 ]---
[473.404331] note: ethtool[1340] exited with preempt_count 1
Segmentation faul [473.411589] ---- ----[ cut here ]------------
lt
---

There is suspicious lines in the file drivers/net/ethernet/freescale/enetc/enetc_ethtool.c:
   { ENETC_PM0_R1523X, "MAC rx 1523 to max-octet packets" },
and:
   { ENETC_PM0_T1523X, "MAC tx 1523 to max-octet packets" },

Where the string length is actually greater than 32 bytes which is more
than the reserved space for the name. This structure is defined as
follow:
    static const struct {
        int reg;
        char name[ETH_GSTRING_LEN];
    } enetc_port_counters[] = { ...

In the function enetc_get_strings(), there is a strlcpy call on the
counters names which in turns calls strlen on the src string, causing
an out-of-bound read, at least out-of the string.

I am not sure that's what caused the BUG, as I don't really know how
fortify works but I thinks this might only be visible when fortify is
enabled.

I am not sure on how to fix this issue, maybe use `char *` instead of
an byte array.

Best,
Jules




