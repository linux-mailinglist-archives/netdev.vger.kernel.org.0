Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 531D03DB709
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 12:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238401AbhG3KST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 06:18:19 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:41274
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238274AbhG3KSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 06:18:18 -0400
Received: from [10.172.193.212] (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 8D3CE3F07B;
        Fri, 30 Jul 2021 10:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627640292;
        bh=6o4Fcv+tz+TApGV06hKVmxuIUEMvqCAQ7bjotfwL0d8=;
        h=To:Cc:From:Subject:Message-ID:Date:MIME-Version:Content-Type;
        b=eZ8FakA3eQSRT5hn9HB05C/gB5uf13uHpJguF+3yl0wwwCJ74tuPMbt7Sf8yW3h40
         EHW13gWc4CAhitkhthIPg13K+gdejQuz8hZYKXu2JASyqWWdt4CjBDfLlIQDMKAke8
         +MKBKIlFd+DE7qC+mOG4bXpKh7mTd21MfUHWt0rlU4cV6DAnsAesrkLJ/LbbOHm21h
         uftx81PlTVjI1QjRvgor5883o6b/R+Rju5KE2rLBUV+WJkIlhp37xbOT2h+Ke9N3ji
         JpY3C6XHovp0o3WnDkJA8txWCCqcYUpK/Hwk0EoorsOFyU5tbd3wnmyKehPrZ0ctJq
         1W0Xs2WHxG0iw==
To:     Manish Chopra <manishc@marvell.com>,
        Rahul Verma <rahulv@marvell.com>, GR-Linux-NIC-Dev@marvell.com
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Colin Ian King <colin.king@canonical.com>
Subject: netxen: mask issue with redundant cases in a switch statement
Message-ID: <26473280-f134-11c4-3dfa-1233c0262c83@canonical.com>
Date:   Fri, 30 Jul 2021 11:18:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Static analysis with Coverity has found an issue in with redundant
deadcode in some cases in a switch statement in
drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c introduced with the
following commit:

commit d612698b6246032370b96abc9afe94c8a66772c2
Author: Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>
Date:   Wed May 9 05:55:29 2012 +0000

    netxen: added miniDIMM support in driver.

The analysis is as follows:

3000        dw = NETXEN_DIMM_DATAWIDTH(val);
3001
3002        dimm.presence = (val & NETXEN_DIMM_PRESENT);
3003
3004        /* Checks if DIMM info is present. */
3005        if (!dimm.presence) {
3006                netdev_err(netdev, "DIMM not present\n");
3007                goto out;
3008        }
3009
3010        dimm.dimm_type = NETXEN_DIMM_TYPE(val);
3011
3012        switch (dimm.dimm_type) {
3013        case NETXEN_DIMM_TYPE_RDIMM:
3014        case NETXEN_DIMM_TYPE_UDIMM:
3015        case NETXEN_DIMM_TYPE_SO_DIMM:
3016        case NETXEN_DIMM_TYPE_Micro_DIMM:
3017        case NETXEN_DIMM_TYPE_Mini_RDIMM:
3018        case NETXEN_DIMM_TYPE_Mini_UDIMM:
3019                break;
3020        default:
3021                netdev_err(netdev, "Invalid DIMM type %x\n",
dimm.dimm_type);
3022                goto out;
3023        }
3024
3025        if (val & NETXEN_DIMM_MEMTYPE_DDR2_SDRAM)
3026                dimm.mem_type = NETXEN_DIMM_MEM_DDR2_SDRAM;
3027        else
3028                dimm.mem_type = NETXEN_DIMM_MEMTYPE(val);
3029
3030        if (val & NETXEN_DIMM_SIZE) {
3031                dimm.size = NETXEN_DIMM_STD_MEM_SIZE;
3032                goto out;
3033        }
3034
3035        if (!rows) {
3036                netdev_err(netdev, "Invalid no of rows %x\n", rows);
3037                goto out;
3038        }
3039
3040        if (!cols) {
3041                netdev_err(netdev, "Invalid no of columns %x\n", cols);
3042                goto out;
3043        }
3044
3045        if (!banks) {
3046                netdev_err(netdev, "Invalid no of banks %x\n", banks);
3047                goto out;
3048        }
3049
3050        ranks += 1;
3051

    between: When switching on dw, the value of dw must be between 0 and 3.

3052        switch (dw) {
3053        case 0x0:
3054                dw = 32;
3055                break;
3056        case 0x1:
3057                dw = 33;
3058                break;
3059        case 0x2:
3060                dw = 36;
3061                break;
3062        case 0x3:
3063                dw = 64;
3064                break;

      Logically dead code (DEADCODE)

3065        case 0x4:
3066                dw = 72;
3067                break;

     Logically dead code (DEADCODE)

3068        case 0x5:
3069                dw = 80;
3070                break;

     Logically dead code (DEADCODE)

3071        case 0x6:
3072                dw = 128;
3073                break;

     Logically dead code (DEADCODE)

3074        case 0x7:
3075                dw = 144;
3076                break;

     Logically dead code (DEADCODE)

3077        default:
3078                netdev_err(netdev, "Invalid data-width %x\n", dw);
3079                goto out;
3080        }
3081

Macro NETXEN_DIMM_DATAWIDTH is defined as:

#define NETXEN_DIMM_DATAWIDTH(VAL)              ((VAL >> 18) & 0x3)

so the value of dw is always going to be in the range 0x00..0x03
inclusive, hence case statments for cases 0x04 to 0x07 are deadcode. Is
the mask correct or should the case statements be removed?

Colin
