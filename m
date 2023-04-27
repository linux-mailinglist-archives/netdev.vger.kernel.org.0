Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1BE36F0436
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 12:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243373AbjD0Kbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 06:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243051AbjD0Kbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 06:31:46 -0400
Received: from mail-4022.proton.ch (mail-4022.proton.ch [185.70.40.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C7CD4C22
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 03:31:43 -0700 (PDT)
Date:   Thu, 27 Apr 2023 10:31:29 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samwein.com;
        s=protonmail3; t=1682591500; x=1682850700;
        bh=gUjNY2H3HinKVRbv/lba0I2hsigojZN47icgo3bY2+Q=;
        h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
        b=fyLva68ucencCA0Z/A06377c4HChNK1kXB63HRjJ7odPBZjcNyssG9YVuW1MmyYvI
         d2zuO3YlUnCP9C0+rlKj+yaonPKL996k+TU5NCh0/4/AX1lZpv3EOROWPMxzH5QFe2
         oPLkSq70wje4ZVvwhxWtcPRTRwjZX322HYq0YOYZeTECiNmQ1M4Q6c7qOB2kUbSYEU
         ZGUDVrnGhT12lzSHiaYH87BkQeRBsEl0a7CnCAyKGVBhvmTSVOSC4BwEsQoNTQ8Tyk
         NMn7ENh6SrdOGyOx9yzX3dOF+0QfBkztwkGLcjL0Azukuu8iiAvUaow0DyFBlLt69f
         s9Cfnnv7tz/GA==
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Samuel Wein PhD <sam@samwein.com>
Subject: NULL pointer dereference when removing xmm7360 PCI device
Message-ID: <Yhw4a065te-PH2rfqCYhLt4RZwLJLek2VsfLDrc8TLjfPqxbw6QKbd7L2PwjA81XlBhUr04Nm8-FjfdSsTlkKnIJCcjqHenPx4cbpRLym-U=@samwein.com>
Feedback-ID: 2153553:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Folks,
I've been trying to get the xmm7360 working with IOSM and the ModemManager.=
 This has been what my highschool advisor would call a "learning process".
When trying `echo 1 > /sys/devices/pci0000:00/0000:00:1c.0/0000:02:00.0/rem=
ove` I get a variety of errors. One of these is a kernel error
`2023-04-27T12:23:38.937223+02:00 Nase kernel: [  587.997430] BUG: kernel N=
ULL pointer dereference, address: 0000000000000048
2023-04-27T12:23:38.937237+02:00 Nase kernel: [  587.997447] #PF: superviso=
r read access in kernel mode
2023-04-27T12:23:38.937238+02:00 Nase kernel: [  587.997455] #PF: error_cod=
e(0x0000) - not-present page
2023-04-27T12:23:38.937241+02:00 Nase kernel: [  587.997463] PGD 0 P4D 0=20
2023-04-27T12:23:38.937242+02:00 Nase kernel: [  587.997476] Oops: 0000 [#1=
] PREEMPT SMP NOPTI
2023-04-27T12:23:38.937242+02:00 Nase kernel: [  587.997489] CPU: 1 PID: 47=
67 Comm: bash Not tainted 6.3.0-060300-generic #202304232030
...
`
the full log is available at https://gist.github.com/poshul/0c5ffbde6106a71=
adcbc132d828dbcd7

Steps to reproduce: Boot device with xmm7360 installed and in PCI mode, pla=
ce into suspend. Resume, and start issuing reset/remove commands to the PCI=
 interface (without properly unloading the IOSM module first).

I'm not sure how widely applicable this is but wanted to at least report it=
.

Sam
