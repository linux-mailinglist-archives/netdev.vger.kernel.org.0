Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3263B05A3
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 15:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbhFVNPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 09:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbhFVNPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 09:15:51 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 101D6C061756
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 06:13:36 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id w31so17066170pga.6
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 06:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :in-reply-to;
        bh=5DS1SwcOilxij9VfrkFEB2z+liOZ/FjVBtqyyXi5udE=;
        b=WZOPm6b7OmBL5PpNqdBfxAVCDsRyeWIlIvCovprNyOsigxaGpqzTdBHg2bx+pgNNk1
         03El9t2brN18ODT8Yis8uM9NPiiZ1k4BL5QTbqXPV5NAsYveSQG8j2RgXfO4ywrSmHNT
         25CK0ojadeXOBnDOaKq++0SUATJMUCh/GmHiE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:in-reply-to;
        bh=5DS1SwcOilxij9VfrkFEB2z+liOZ/FjVBtqyyXi5udE=;
        b=MITzR2NYNPFTLU6W+DFdXa0n2aA5zlE4tVoNwvSZw3l565160dnQldqn1OpYJxVWpw
         N/3tiFnaB8n/a8wZZYPs+DMX7ImXqn/u3onqz8r5XD1lDzLLtbtAxt+M97ti9yJJtIyT
         CSfkf25tPvmKqs3VQa38R+2nc2/jWw8doaGZWS09oBtTWo4q6uqJm62GVyPhVJvuCAvg
         E3+uOeSIM+bv+xO35k02dQvB/cDEO10R25FVvF4GQWXgGnV/Mifuk0FldPmDgUmKEjdz
         uYFMhVW5ECNbE/K4pmKhG+ZK8W+Jiz3hN6YidTXJ2P6WGIN6XSgMRvecW/PAAXmCAfGN
         ljSw==
X-Gm-Message-State: AOAM531goW6VXpZWpcrBK8fT5ZZJKARTMBlxtiG+lV013g4T7CzfIfZm
        boVD//dvat8ZiWVgXjqxK/KpHQ==
X-Google-Smtp-Source: ABdhPJx7fOnSnjQSvnXteE9qsQv3TVMu5Zwq4YmKgkOFcbnkXFLgtM9p7SRufMx6kfq3e1gUmLMoww==
X-Received: by 2002:a63:af07:: with SMTP id w7mr3792813pge.287.1624367615325;
        Tue, 22 Jun 2021 06:13:35 -0700 (PDT)
Received: from builder ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id e13sm8401341pfd.8.2021.06.22.06.13.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 06:13:34 -0700 (PDT)
Date:   Tue, 22 Jun 2021 16:13:14 +0300
From:   Boris Sukholitko <boris.sukholitko@broadcom.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jiri@resnulli.us, idosch@idosch.org, ilya.lifshits@broadcom.com
Subject: Re: [PATCH net-next] net/sched: cls_flower: fix resetting of ether
 proto mask
Message-ID: <20210622131314.GA14973@builder>
References: <20210617161435.8853-1-vadym.kochan@plvision.eu>
 <20210617164155.li3fct6ad45a6j7h@skbuf>
 <20210617195102.h3bg6khvaogc2vwh@skbuf>
 <20210621083037.GA9665@builder>
 <f18e6fee-8724-b246-adf9-53cc47f9520b@mojatatu.com>
MIME-Version: 1.0
In-Reply-To: <f18e6fee-8724-b246-adf9-53cc47f9520b@mojatatu.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000ba017105c55a8eb0"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000ba017105c55a8eb0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jamal,

On Mon, Jun 21, 2021 at 10:04:41AM -0400, Jamal Hadi Salim wrote:
> On 2021-06-21 4:32 a.m., Boris Sukholitko wrote:
> > On Thu, Jun 17, 2021 at 10:51:02PM +0300, Vladimir Oltean wrote:
> > > On Thu, Jun 17, 2021 at 07:41:55PM +0300, Vladimir Oltean wrote:
> > > > On Thu, Jun 17, 2021 at 07:14:35PM +0300, Vadym Kochan wrote:
> > 
> > [snip excellent problem analysis]
> > 
> > > So maybe it is the flow dissector we need to fix, to make it give us an
> > > additional pure EtherType if asked for, make tc-flower use that
> > > dissector key instead, and then revert Jamal's user space patch, and we
> > > should all install our tc filters as:
> > > 
> > > tc filter add dev sw1p0 ingress handle 11 protocol all flower eth_type 0x8864 skip_hw action drop
> > > 
> > > ?
> > 
> > I like this solution. To be more explicit, the plan becomes:
> > 
> > 1. Add FLOW_DISSECTOR_KEY_ETH_TYPE and struct flow_dissector_key_eth_type.
> > 2. Have skb flow dissector use it.
> > 3. Userspace does not set TCA_FLOWER_KEY_ETH_TYPE automagically
> >     anymore. cls_flower takes basic.n_proto from struct tcf_proto.
> > 4. Add eth_type to the userspace and use it to set TCA_FLOWER_KEY_ETH_TYPE
> > 5. Existence of TCA_FLOWER_KEY_ETH_TYPE triggers new eth_type dissector.
> > 
> > IMHO this neatly solves non-vlan protocol match case.
> > 
> > What should we do with the VLANs then? Should we have vlan_pure_ethtype
> > and cvlan_pure_ethtype as additional keys?
> > 
> 
> I didnt see the original patch you sent until after it was applied
> and the cursory 30 second glance didnt say much to me.
> 
> Vlans unfortunately are a speacial beast: You will have to retrieve
> the proto differently.

Do you by any chance have some naming suggestion? Does
vlan_pure_ethtype sound ok? What about vlan_{orig, pkt, raw, hdr}_ethtype?

> 
> Q: Was this always broken? Example look at Toke's change here:
> commit d7bf2ebebc2bd61ab95e2a8e33541ef282f303d4
> 

IMHO we've always had this problem. I did some archeology on this
code and didn't see anything which might have caused the bug.

Toke's change doesn't look related because in fl_classify it does:

	skb_key.basic.n_proto = skb_protocol(skb, false);

before running the dissector. In case of a known tunnelling protocol (such
as ETH_P_PPP_SES) the n_proto will be overriden by __skb_flow_dissect.

Thanks,
Boris.

> cheers,
> jamal

--000000000000ba017105c55a8eb0
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
s4pyqb3D0zeGSCUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIB2ZIPiXxJDbOZ99
o52ye8d38Ylc8gaZm1bidJ7qLtYDMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIxMDYyMjEzMTMzNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAawjxXx1YvYQ0jIZ3n6EDf8P3kIRXVovHr
Lo6KGZnnyFIq2W97a/jnCfI/SpMFhOaaW4K8/8yxjRKGt2b9Spe8GBR86zVbMjGxvQk7DzuwRQk0
mCRmYHt1ynyG0InbuI0fXiYSW/e4gwwqcAtx7ZewseUsDVJ8qhwK9MnxbuogOq5IbtDUdqadkvmY
HYG5o+Cy7QQIhcYYrsXPjd3ZO/DHQsHkQ3t3nrP+TUjwLDBzjA8Uy0wAU4v8s4502kJbh/LhwBE4
askwp4D5dkO64Dd7FVMJpcpMXJ5xuFdADu2IW2/ZthgUbnYs8UYoMUm8fWg0dB5gNXCKiWGqTQTe
eLCQ
--000000000000ba017105c55a8eb0--
