Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAC1C3AE4F6
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 10:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbhFUIfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 04:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbhFUIfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 04:35:05 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03438C061768
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 01:32:52 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id q192so6506642pfc.7
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 01:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :in-reply-to;
        bh=6ZJn+sUxTfG5lhi66ImBULrHKOaTwmrVhRA//dpOHA8=;
        b=XEs6mPLZIU/uIV24bwBmM9XxTF28uq7WeBAJ2REAuKlyJRXUwxlSr/IhnJEc3qVATB
         m+cCCmoFeuvCH7Yx0RjHv3dpaBFQUv4uD4cOExBG3PTsTHQMXeo1PmOZBcpkidyBgd/w
         1S37AlGoORd0wBrwu/APbtHPFG1m1MaJAsflQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:in-reply-to;
        bh=6ZJn+sUxTfG5lhi66ImBULrHKOaTwmrVhRA//dpOHA8=;
        b=YTdOOshf3TTGfrR5Kbj5fRWfo9YEuV3PkAbnnd+gpmQb8mPol+vWBvA7BXHnnQf88x
         2n3CSpaQNMj09/xKRo8M5EM9er+f8rFBBXYTu4c0x+DGNMSnezNeffxorNByovnC8Jd8
         KonywulIAo5wHnFZyghMJrPwqVqjMT2YZHc1dtoTtFoNzBJl3X03DHMPrG/jtkUh/bPr
         lOkMPvQe//icmbYE0Th8Sfn9UytanG0Klvo7tPP/WUPCyIyZUItq3eiLOyKCYTsGx9F1
         e+rglM1SyYSwSBV+uRmhbHnmk1Ei9Rucax04XV7jD2QSeI47hC/MryqnW/vVqXdUPcbT
         3rFA==
X-Gm-Message-State: AOAM531ReT5pa/WbU6WuB/l2sUaw3pL0lppvvDXgMqYJHi29R2IuhQoU
        SsQBIJbHUKFMDLiSnaQq8F4czw==
X-Google-Smtp-Source: ABdhPJz2tpCGCCI3Z2IIvVTVcTTwa09w9FNWNP/0zHjW2psUw8/aL3DOktfkxXO0y9m+D4ujjxLYtw==
X-Received: by 2002:a63:da04:: with SMTP id c4mr9526221pgh.348.1624264371431;
        Mon, 21 Jun 2021 01:32:51 -0700 (PDT)
Received: from builder ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id h20sm14026684pfh.24.2021.06.21.01.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 01:32:50 -0700 (PDT)
Date:   Mon, 21 Jun 2021 11:32:27 +0300
From:   Boris Sukholitko <boris.sukholitko@broadcom.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jiri@resnulli.us, idosch@idosch.org, ilya.lifshits@broadcom.com
Subject: Re: [PATCH net-next] net/sched: cls_flower: fix resetting of ether
 proto mask
Message-ID: <20210621083037.GA9665@builder>
References: <20210617161435.8853-1-vadym.kochan@plvision.eu>
 <20210617164155.li3fct6ad45a6j7h@skbuf>
 <20210617195102.h3bg6khvaogc2vwh@skbuf>
MIME-Version: 1.0
In-Reply-To: <20210617195102.h3bg6khvaogc2vwh@skbuf>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000e6cd8105c54284dc"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000e6cd8105c54284dc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 17, 2021 at 10:51:02PM +0300, Vladimir Oltean wrote:
> On Thu, Jun 17, 2021 at 07:41:55PM +0300, Vladimir Oltean wrote:
> > On Thu, Jun 17, 2021 at 07:14:35PM +0300, Vadym Kochan wrote:

[snip excellent problem analysis]

> So maybe it is the flow dissector we need to fix, to make it give us an
> additional pure EtherType if asked for, make tc-flower use that
> dissector key instead, and then revert Jamal's user space patch, and we
> should all install our tc filters as:
> 
> tc filter add dev sw1p0 ingress handle 11 protocol all flower eth_type 0x8864 skip_hw action drop
> 
> ?

I like this solution. To be more explicit, the plan becomes:

1. Add FLOW_DISSECTOR_KEY_ETH_TYPE and struct flow_dissector_key_eth_type.
2. Have skb flow dissector use it.
3. Userspace does not set TCA_FLOWER_KEY_ETH_TYPE automagically
   anymore. cls_flower takes basic.n_proto from struct tcf_proto.
4. Add eth_type to the userspace and use it to set TCA_FLOWER_KEY_ETH_TYPE
5. Existence of TCA_FLOWER_KEY_ETH_TYPE triggers new eth_type dissector.

IMHO this neatly solves non-vlan protocol match case.

What should we do with the VLANs then? Should we have vlan_pure_ethtype
and cvlan_pure_ethtype as additional keys?

> 
> Or maybe just be like you, say I don't care about any of that, I just
> want it to behave as before, and simply revert Boris's patch. Ok, maybe

FTR I fully support reverting the patch. Please accept my apologies for
breaking the HW offload and big thanks to Vadym for finding it.

I will send the revert shortly.

Thanks,
Boris.

--000000000000e6cd8105c54284dc
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBVgwggRAoAMCAQICDDSzinKpvcPTN4ZIJTANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIwNzMwMDRaFw0yMjA5MDUwNzM3NTVaMIGW
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xGTAXBgNVBAMTEEJvcmlzIFN1a2hvbGl0a28xLDAqBgkqhkiG
9w0BCQEWHWJvcmlzLnN1a2hvbGl0a29AYnJvYWRjb20uY29tMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEAy/C7bjpxs+95egWV8sWrK9KO0SQi6Nxu14tJBgP+MOK5tvokizPFHoiXTymZ
7ClfnmbcqT4PzWgI3thyfk64bgUo1nQkCTApn7ov3IRsWjmHExLSNoJ/siUHagO6BPAk4JSycrj5
9tC9sL4FnIAbAHmOSILCyGyyaBAcmiyH/3toYqXyjJkK+vbWQSTxk2NlqJLIN/ypLJ1pYffVZGUs
52g1hlQtHhgLIznB1Qx3Fop3nOUk8nNpQLON/aM8K5sl18964c7aXh7YZnalUQv3md4p2rAQQqIR
rZ8HBc7YjlZynwOnZl1NrK4cP5aM9lMkbfRGIUitHTIhoDYp8IZ1dwIDAQABo4IB3jCCAdowDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDAoBgNVHREEITAfgR1ib3Jpcy5zdWtob2xpdGtvQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggr
BgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUtBmGs9S4
t1FcFSfkrP2LKQQwBKMwDQYJKoZIhvcNAQELBQADggEBAJMAjVBkRmr1lvVvEjMaLfvMhwGpUfh6
CMZsKICyz/ZZmvTmIZNwy+7b9r6gjLCV4tP63tz4U72X9qJwfzldAlYLYWIq9e/DKDjwJRYlzN8H
979QJ0DHPSJ9EpvSKXob7Ci/FMkTfq1eOLjkPRF72mn8KPbHjeN3VVcn7oTe5IdIXaaZTryjM5Ud
bR7s0ZZh6mOhJtqk3k1L1DbDTVB4tOZXZHRDghEGaQSnwU/qxCNlvQ52fImLFVwXKPnw6+9dUvFR
ORaZ1pZbapCGbs/4QLplv8UaBmpFfK6MW/44zcsDbtCFfgIP3fEJBByIREhvRC5mtlRtdM+SSjgS
ZiNfUggxggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52
LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgw0
s4pyqb3D0zeGSCUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIOzGjO/DU4yBHSzW
DNem/BlQOhipf5giIOIoLMJAYlB5MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIxMDYyMTA4MzI1MVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAdEO4smy2DsCffceS98rzlh0cLoYh+5Mnx
MTdFv7lWH3iCkfkB5RAEo7RbOn0Mb8f/PAvHeINZeVg36d8zonPfzXvLbSwH2ZOIj8ZapH0TEW4a
91BjAFBnj7IkL2guzpldQgEi1PybuQh73RXNDxx4402LLCihANQ3bmZI5S4UgkdbTjTYBlJYqBTc
aIKCa+e9M5P8u2PI4tF99t4qIgEzXLO4MVh82eNBDJdhQ0BkROJbauo7a33VSmn7t4NcLWR4VuVv
KOLWy/FhkdatTci/w3mzTjYLu1sAvp3uZzDvYmh2Pzbfbcf6VDqBjn2fbFhw2MePDXDfwk9E1sv6
hl6d
--000000000000e6cd8105c54284dc--
