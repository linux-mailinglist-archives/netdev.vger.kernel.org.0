Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3B627DB55
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 00:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbgI2WEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 18:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728450AbgI2WEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 18:04:32 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB2E8C0613D2
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 15:04:31 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id t7so3512850pjd.3
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 15:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=z4SquiSlQZl81nrHJ774uVW+9LNapS/LU60IGGrjA8I=;
        b=Ti2DEFfmYuFiu4olmNQLpkJH4NIjOFRwiooQPd+ye9ebSpmkSkJBzdn1ib1UzP5Sa8
         4uVe7dTwRmYeCYDZXEw6OZKS7vS1FKZ0cJpI7jUBaVkkEsyMHZPolkRSDFppddG1R7lB
         1i2Rt0RK/ZfSkcT573o0Yov7LLy2PZEblNpPs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to;
        bh=z4SquiSlQZl81nrHJ774uVW+9LNapS/LU60IGGrjA8I=;
        b=hvLJs4AvKb4CdTexZbvU0krNDL628tkSEKirz08tvQRcJYYnzQVf/D6b56dKOhpGKu
         DZb4enrsVtNQHlQrT6bqVNTHiTT9Q22jOQwWslGM3xbQVUnw+ZsyKfv3/kc9lZ8Dfnwz
         b5Lo1h7CTi3J9KCBgt6IbPegA/U9KK0zlwo1ad85/aQNC2wMrcVoXR4ohyfSTyrs0d9O
         mcGoaZrXeRyZ1PYMe0Y4ChEHLUsXQHc0xy7642JAED9nlpD9v7nD6kF+hzMQjFz7ulb0
         LQPyMRAP53D14raytsilM6sKtRTmynFPdPnmmqXogN4dj/16cpL9mLiJi8h4scG73yyX
         wteQ==
X-Gm-Message-State: AOAM531mT1ktzmqSDInHccRfmkmcEeY1fYvig5eKYV/vO0otBsIFYF3G
        OY9p/c+1xR/81PxPxvd4rmDUEA==
X-Google-Smtp-Source: ABdhPJxV8EYQ9JnZPsQ8dHML9HhEOBxyLiQEpEqoA3u063+yClHhtgTpIqKkckYAsWnYdNPuZLZSzw==
X-Received: by 2002:a17:90b:80a:: with SMTP id bk10mr5622687pjb.53.1601417071046;
        Tue, 29 Sep 2020 15:04:31 -0700 (PDT)
Received: from [192.168.178.129] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id q193sm6593198pfq.127.2020.09.29.15.04.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 15:04:30 -0700 (PDT)
Subject: Re: [patch V2 26/36] net: brcmfmac: Convey execution context via
 argument to brcmf_netif_rx()
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Dave Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-doc@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        Jon Mason <jdmason@kudzu.us>, Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Jouni Malinen <j@w1.fi>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        libertas-dev@lists.infradead.org,
        Pascal Terjan <pterjan@google.com>,
        Ping-Ke Shih <pkshih@realtek.com>
References: <20200929202509.673358734@linutronix.de>
 <20200929203502.084703195@linutronix.de>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <0f26e8be-bfb1-7e69-3a8d-a5ef2bf22b25@broadcom.com>
Date:   Wed, 30 Sep 2020 00:03:59 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200929203502.084703195@linutronix.de>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000af75d605b07af7eb"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000af75d605b07af7eb
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 9/29/2020 10:25 PM, Thomas Gleixner wrote:
> bcrmgf_netif_rx() uses in_interrupt to chose between netif_rx() and
> netif_rx_ni(). in_interrupt() usage in drivers is phased out.
> 
> Convey the execution mode via an 'inirq' argument through the various
> callchains leading to brcmf_netif_rx():
> 
> brcmf_pcie_isr_thread()		    <- Task context
>    brcmf_proto_msgbuf_rx_trigger()
>      brcmf_msgbuf_process_rx()
>        brcmf_msgbuf_process_msgtype()
>          brcmf_msgbuf_process_rx_complete()
> 	  brcmf_netif_mon_rx()
> 	     brcmf_netif_rx(isirq = false)
> 	  brcmf_netif_rx(isirq = false)
> 
> brcmf_sdio_readframes()  <- Task context sdio_claim_host() might sleep
>    brcmf_rx_frame(isirq = false)
> 
> brcmf_sdio_rxglom()      <- Task context sdio_claim_host() might sleep
>    brcmf_rx_frame(isirq = false)
> 
> brcmf_usb_rx_complete()  <- Interrupt context
>    brcmf_rx_frame(isirq = true)
> 
> brcmf_rx_frame()
>    brcmf_proto_rxreorder()
>      brcmf_proto_bcdc_rxreorder()
>        brcmf_fws_rxreorder()
>          brcmf_netif_rx()
>        brcmf_netif_rx()

Thanks for taking the dive.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> ---
> V2: New patch. Using an argument instead of switching to netif_rx_any_context()
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c     |    4 +--
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h      |    3 +-
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c     |   16 ++++++------
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h     |    2 -
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c |   10 +++----
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.h |    2 -
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c   |    5 ++-
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h    |    6 ++--
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c     |    4 +--
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c      |    2 -
>   10 files changed, 29 insertions(+), 25 deletions(-)

--000000000000af75d605b07af7eb
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
pra5sIx/TR6gNtLG9MpND9zQt5j42hInkP81vqu9DG8lovoPMuR0JVpFRbPjHZ07cLqqbFMVS/8z
53iSewIDAQABo4IB0zCCAc8wDgYDVR0PAQH/BAQDAgWgMIGeBggrBgEFBQcBAQSBkTCBjjBNBggr
BgEFBQcwAoZBaHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NwZXJzb25hbHNp
Z24yc2hhMmczb2NzcC5jcnQwPQYIKwYBBQUHMAGGMWh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNv
bS9nc3BlcnNvbmFsc2lnbjJzaGEyZzMwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYB
BQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAw
RAYDVR0fBD0wOzA5oDegNYYzaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3BlcnNvbmFsc2ln
bjJzaGEyZzMuY3JsMCcGA1UdEQQgMB6BHGFyZW5kLnZhbnNwcmllbEBicm9hZGNvbS5jb20wEwYD
VR0lBAwwCgYIKwYBBQUHAwQwHwYDVR0jBBgwFoAUaXKCYjFnlUSFd5GAxAQ2SZ17C2EwHQYDVR0O
BBYEFHAaaA+cRo3vYiA6aKVu1bOs4YAYMA0GCSqGSIb3DQEBCwUAA4IBAQCYLdyC8SuyQV6oa5uH
kGtqz9FCJC/9gSclQLM8dZLHF3FYX8LlcQg/3Ct5I29YLK3T/r35B2zGljtXqVOIeSEz7sDXfGNy
3dnLIafB1y04e7aR+thVn5Rp1YTF01FUWYbZrixlVuKvjn8vtKC+HhAoDCxvqnqEuA/8Usn7B0/N
uOA46oQTLe3kjdIgXWJ29JWVqFUavYdcK0+0zyfeMBCTO6heYABeMP3wzYHfcuFDhqldTCpumqhZ
WwHVQUbAn+xLMIQpycIQFoJIGJX4MeaTSMfLNP2w7nP2uLNgIeleF284vS0XVkBXSCgIGylP4SN+
HQYrv7fVCbtp+c7nFvP7MYICbzCCAmsCAQEwbTBdMQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xv
YmFsU2lnbiBudi1zYTEzMDEGA1UEAxMqR2xvYmFsU2lnbiBQZXJzb25hbFNpZ24gMiBDQSAtIFNI
QTI1NiAtIEczAgxR3m7Pj6LvQiWjJy0wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIE
INJ8F6w6EaA9wgPRH3Sdj0IbzO/Po40dTzz45z3/fFdhMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0B
BwEwHAYJKoZIhvcNAQkFMQ8XDTIwMDkyOTIyMDQzMVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgB
ZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQow
CwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCK/4TQqgRRDqyjck+9
LWboW9/YxwzH2vrmoYtwS/9rIjLv7TsUnFzyChuroz85ir9JDBGjoPakVZC01hEyUfAIncvpXJ17
7vAzEpzNFY/fTMWyDRi6miG0c+fnHvLTTWQyrHQxUWra7jnq8yZNchT8PMsL1238IxkZ4Pzk/iK6
FEZn24/CXQHAMf6MNRciKBlYhZ79++nfHUz56jz7wIVMyaFF4EpPmlkdiJHALV2X8nZgjKMt2NDQ
xis2OiLPNzEa7G6iRQUCTK2XN6+jBFehUCwPsnPHU6ugMfc0s63/tvDRjq6/V9v5OUccqGTd+cfh
GJOI1HbKrmruLU2nASsy
--000000000000af75d605b07af7eb--
