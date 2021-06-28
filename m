Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53DF33B591A
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 08:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbhF1G1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 02:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhF1G1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 02:27:21 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1269FC061574
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 23:24:56 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id h4so14576224pgp.5
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 23:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :in-reply-to;
        bh=ftmArVHBnjaiqwLqmNckLLOV/rfNZ49SB3JHiTFd1Q8=;
        b=cY/ejyQcjfUUFLOiZj9r+yav3Ij6o0rkpvgTT/IxDPz7+pMlWMAP8OeIgzWLkgcb9A
         1lb2B9A/ujVeyPZVwvtpj4OMi5nnBsSkUXzagrL1udlwvCl954qsRA9gM2yN1KvItyek
         g2XZ+E9xt03DjW0dJLkKr+4OBUmIAT4trVpSQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:in-reply-to;
        bh=ftmArVHBnjaiqwLqmNckLLOV/rfNZ49SB3JHiTFd1Q8=;
        b=VUtpfK4/muQQ7Ot4YJEy2KT1wJA3osaVoCteDIObMhO90ch483QlRa7kUVDepUXH59
         Hjs+7MJ7oKq5OYc1AcICR1pNjF+/K2g7IYydkh/GDObZ3yWsp38l/eYJIrZ5meQzjHSK
         AIxf+RMym/Xx/C+nc6SmfKW2Ye6CKwXKw68VwvLYTwkJEVzi5i+qqQYq8je+imOzbI6B
         pA+l0sVipuRIFVH4VuGvU0zVr+posnB8HeePuJRueqx0lqeJU87Ou6ZgZUf7fH2cPnOR
         wtfEz2erdz6R6iPn+p2GLaHipNJctQAJ+zMX4XZ/Fxtjq65yr8N/hI8fwUL6wX4RRh3T
         9gDQ==
X-Gm-Message-State: AOAM532NPo0/2Z3eZJfytmY+33Uf6IMNeYHgu11t0WhF0rA4+rRMzbpl
        XHlgXEpJz3/yKUezdgm9RYQnkw==
X-Google-Smtp-Source: ABdhPJzMesSDkFORP5hxE2I+QpOwurW1y2yvhe+6cHNwAJ7XgwzdIpLoQg93TKeTBobjBXbsYSs2dw==
X-Received: by 2002:a63:cf4e:: with SMTP id b14mr8076988pgj.125.1624861495448;
        Sun, 27 Jun 2021 23:24:55 -0700 (PDT)
Received: from noodle ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id w14sm13384658pjb.3.2021.06.27.23.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 23:24:54 -0700 (PDT)
Date:   Mon, 28 Jun 2021 09:24:34 +0300
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
Message-ID: <20210628062434.GA13594@noodle>
References: <20210617161435.8853-1-vadym.kochan@plvision.eu>
 <20210617164155.li3fct6ad45a6j7h@skbuf>
 <20210617195102.h3bg6khvaogc2vwh@skbuf>
 <20210621083037.GA9665@builder>
 <f18e6fee-8724-b246-adf9-53cc47f9520b@mojatatu.com>
 <20210622131314.GA14973@builder>
 <451abd22-4c81-2821-e8d4-4f305697890c@mojatatu.com>
 <20210622152218.GA1608@noodle>
 <7d0367ab-22e4-522a-11ef-8fb376672b54@mojatatu.com>
MIME-Version: 1.0
In-Reply-To: <7d0367ab-22e4-522a-11ef-8fb376672b54@mojatatu.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000044f7ce05c5cd8cf2"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000044f7ce05c5cd8cf2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jamal,

On Thu, Jun 24, 2021 at 04:07:56PM -0400, Jamal Hadi Salim wrote:
> Hi Boris,
> 
> Apologies for the latency.
> 

Apparently mine is not great either. :)

> On 2021-06-22 11:22 a.m., Boris Sukholitko wrote:
> > On Tue, Jun 22, 2021 at 10:17:45AM -0400, Jamal Hadi Salim wrote:
> 
> [..]
> 
> > > > Do you by any chance have some naming suggestion? Does
> > > > vlan_pure_ethtype sound ok? What about vlan_{orig, pkt, raw, hdr}_ethtype?
> > > > 
> > > 
> > > The distinction is in getting the inner vs outer proto, correct?
> > 
> > Yes. To be more explicit: the outer protocol (ETH_P_PPP_SES in this case) is
> > invisible to the user due to __skb_flow_dissect drilling down
> > to find the inner protocol.
> 
> Ok, seems this is going to be problematic for flower for more than
> just ETH_P_PPP_SES, no? i.e anything that has an inner proto.
> IIUC, basically what you end up seeing in fl_classify() is
> the PPP protocol that is extracted by the dissector?
> 

Yes. It looks like the problem for all of tunnel protocols.

> > Yes. Talking specifically about flower's fl_classify and the following
> > rule (0x8864 is ETH_P_PPP_SES):
> > 
> > tc filter add dev eth0 ingress protocol 0x8864 flower action simple sdata hi6
> > 
> > skb_flow_dissect sets skb_key.basic.n_proto to the inner protocol
> > contained inside the PPP tunnel. fl_mask_lookup will fail finding the
> > outer protocol configured by the user.
> > 
> 
> For vlans it seems that flower tries to "rectify" the situation
> with skb_protocol() (that why i pointed to that function) - but the
> situation in this case cant be rectified inside fl_classify().
> 
> Just quick glance of the dissector code though seems to indicate
> skb->protocol is untouched, no? i.e if you have a simple pppoe with
> ppp protocol == ipv4, skb->protocol should still be 0x8864 on it
> (even when skb_key.basic.n_proto has ipv4).
> 

The skb->protocol is probably untouched. Unfortunately I don't see
how this may help us... 

> 
> > It looks to me that there is no way to match on outer protocol such as
> > ETH_P_PPP_SES at least in flower. Although other filters (e.g. matchall)
> > will work, VLAN packets containing ETH_P_PPP_SES will require flower and
> > still will not match.
> 
> This is a consequence of flower using flow_dissector and flow
> dissector loosing information..
> 

Yes.

> > > This is because when vlan offloading was merged it skewed
> > > things a little and we had to live with that.
> > > 
> > > Flower is unique in its use of the dissector which other classifiers
> > > dont. Is this resolvable by having the fix in the  dissector?
> > 
> > Yes, the solution suggested by Vladimir and elaborated by myself
> > involves extending the dissector to keep the outer protocol and having
> > flower eth_type match on it. This is the "plan" being quoted above.
> > 
> >
> > I believe this is the solution for the non-vlan tagged traffic. For the
> > vlans we already have [c]vlan_ethtype keys taken. Therefore we'll need
> > new [c]vlan_outer_ethtype keys.
> > 
> 
> I think that would work in the short term but what happens when you
> have vlan in vlan carrying pppoe? i.e how much max nesting can you
> assume and what would you call these fields?
> 

Currently flower matches on 2 level of vlans: e.g. it has vlan_prio for
the outer vlan and cvlan_prio for the inner vlan. I have no ambition to
go beyond that. Thus only two keys will be needed: vlan_outer_ethtype
and cvlan_outer_ethtype, I think...

In your vlan in vlan ppoe example, I hope that
cvlan_outer_ethtype == ETH_P_PPP_SES will match.

Thanks,
Boris.

> cheers,
> jamal
> 

--00000000000044f7ce05c5cd8cf2
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
s4pyqb3D0zeGSCUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIHCGAU9+yj4zD6YP
XyD8XTwRlMvDWPK47ZpO33OgbNi1MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIxMDYyODA2MjQ1NVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQDHTnTgGkGDuWDbZddyEpwrUkjoEQZI7BNu
7lpP4/Wxg1+r1J4Qt/BICBzMcplSSNTjUR4YuAiQgxW70v+7+wdP3DCtiVrxB8pwUcoBFEoZPzDe
58IgtpZL+Xa32CQ2Eud/tcDx+p9uDswhUlK9gVupU+Fq96bIvZqKWkcI27GLCSLnx2cArFLkm4QD
oztN7VNGFCS5s3o1HBEWPS32WiIz7gGyHWn58LIBxUPN7TU/NTMDF8mxX8VBNmzpHEwaMRh70lLx
jp987Gniz00fIX+etXbZa+WP/9LdD0Z6uamCWtQCbdoF0q6H8IN2JGJqjFwB9bH8Vqxh61Y3AmWu
dyzu
--00000000000044f7ce05c5cd8cf2--
