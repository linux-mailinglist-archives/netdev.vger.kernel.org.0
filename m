Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3DFF4FE022
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349694AbiDLMaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354326AbiDLM23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:28:29 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F162B1
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 04:41:03 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id be5so10571646plb.13
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 04:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :in-reply-to;
        bh=Kbbts5bCUtBKKQr1c0nCUtPIzhk6nh9/H8hNLr9at9g=;
        b=cDVkr5HqmTJnKne5g+wU+aqPfwU/JnCR1dPl10/Jvk70F0FErYNa3SgKAhJsjbypzp
         XLTp40FUajkgFR89m1B7Iy2LUSom+siRQsH7Oe4U5P8Tl+vhMHU25HVxWhOq7sSO8DqP
         Awi9MvDaqc0fW/iWQYiWq4yLM8+JyEqoyLJEE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:in-reply-to;
        bh=Kbbts5bCUtBKKQr1c0nCUtPIzhk6nh9/H8hNLr9at9g=;
        b=zLAEX4PYeBOmrlwBgQ/2/F2Of3C5WsZzW5MCFcH6YuNwWMEkPAu0C/Pgn04c3j02IX
         45jMMd2r2b9C9XFDhDAIfe0gyJO8vkGEPZY5v6AOcaOCDff72s17GbARr3rjpmhXUhRI
         16Uy8vxrRs0ee566uEYiNw/rcCaM3KCp9KcNf28zP7RrXz1Ap9BR+k6lQeUpwjJnaVU5
         pj1alZxA0BBl+m985TKAUKFN72g7TrmnZf99In2nDfAjjiLJXSx0BDeEpTs5WlVJnqd/
         pT3MOUkhVM8FV+BqVfGWuk4ymf6vVxhBaspY22SvG4Nmn2agvPltURLPmjSAdm1AYAr1
         /a1A==
X-Gm-Message-State: AOAM533kGYNqEPijj7ZoOKrQCjbJhYVvPvQW6K9qb8pZFYTo9U/yAvKg
        h1zmu0lWhU/zNPSlFuUsB4ZgNw==
X-Google-Smtp-Source: ABdhPJwKFSc263HeMGfQwWBBkpjHj8Btigieo6QMOL3e95Z8hCtPYNIhNz4KzWKyvctG+J46vaqj8g==
X-Received: by 2002:a17:902:6bc4:b0:154:6b3d:a720 with SMTP id m4-20020a1709026bc400b001546b3da720mr36542980plt.104.1649763662709;
        Tue, 12 Apr 2022 04:41:02 -0700 (PDT)
Received: from noodle ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id l25-20020a635719000000b0039da6cdf82dsm485164pgb.83.2022.04.12.04.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 04:41:02 -0700 (PDT)
Date:   Tue, 12 Apr 2022 14:40:49 +0300
From:   Boris Sukholitko <boris.sukholitko@broadcom.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        zhang kai <zhangkaiheb@126.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>
Subject: Re: [PATCH net-next v2 5/5] net/sched: flower: Consider the number
 of tags for vlan filters
Message-ID: <20220412114049.GA2451@noodle>
References: <20220412100236.27244-1-boris.sukholitko@broadcom.com>
 <20220412100236.27244-6-boris.sukholitko@broadcom.com>
 <YlVd79bM00wuK9yW@nanopsycho>
MIME-Version: 1.0
In-Reply-To: <YlVd79bM00wuK9yW@nanopsycho>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000018857f05dc73894e"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000018857f05dc73894e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 12, 2022 at 01:09:35PM +0200, Jiri Pirko wrote:
> Tue, Apr 12, 2022 at 12:02:36PM CEST, boris.sukholitko@broadcom.com wrote:
> >Currently the existence of vlan filters is conditional on the vlan
> >protocol being matched in the tc rule. I.e. the following rule:
> >
> >tc filter add dev eth1 ingress flower vlan_prio 5
> >
> >is illegal because we lack protocol 802.1q in the rule.
> >
> >Having the num_of_vlans filter configured removes this restriction. The
> >following rule becomes ok:
> >
> >tc filter add dev eth1 ingress flower num_of_vlans 1 vlan_prio 5
> >
> >because we know that the packet is single tagged.
> >
> >We achieve the above by having is_vlan_key helper look at the number of
> 
> Sorry to be a nitpicker, but who's "we"? When I read the patch
> description, I need to understand clearly what the patch is doing, which
> is not this case. You suppose to command the codebase what to do.
> I fail to see that :/
> 
> 

What do you think of the following description? The description consists
of two parts: the first provides motivation for the patch, the second is
the way the motivation is implemented. I've judiciously edited out the
"we"-word. :)

<description>

Currently the existence of vlan filters is conditional on the vlan
protocol being matched in the tc rule. I.e. the following rule:

tc filter add dev eth1 ingress flower vlan_prio 5

is illegal because vlan protocol (e.g. 802.1q) does not appear in the rule.

Having the num_of_vlans filter configured removes this restriction. The
following rule becomes ok:

tc filter add dev eth1 ingress flower num_of_vlans 1 vlan_prio 5

because having num_of_vlans==1 implies that the packet is single tagged.

To make the above possible, is_vlan_key helper is changed to look at the
number of vlans in addition to the vlan ethertype.

Outer tag vlan filters (e.g.  vlan_prio) require the number of vlan tags
be greater than 0. Inner filters (e.g. cvlan_prio) require the number of
vlan tags be greater than 1.

Number of vlans filter may cause ethertype to be set to 0.
fl_set_key_vlan is changed to accomodate this.

</description>

Thanks,
Boris.

> >vlans in addition to the vlan ethertype. Outer tag vlan filters (e.g.
> >vlan_prio) require the number of vlan tags be greater than 0. Inner
> >filters (e.g. cvlan_prio) require the number of vlan tags be greater
> >than 1.
> >
> >Number of vlans filter may cause ethertype to be set to 0. Check this in
> >fl_set_key_vlan.
> >

--00000000000018857f05dc73894e
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
s4pyqb3D0zeGSCUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIHkau08a3F5p6Qb7
sHpgnBgGSO19X8XZ9W2tiVVOq0WMMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIyMDQxMjExNDEwMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAeCV7+As7VSVY12qSgp6YqOLyHWldgSdB4
+vkiosuHS2yfSSwypRdpY1YkV3tex/tgHm6qK4AIZjCKzeDtEJUaxX4E/MK0W1tNcJvVgb22Zhs9
lhAoEj89xuniRl5uyUx+vNviLtppUKNYV3qMOnLdRP1u67nMCZowEBoV+U71KF8bpp7+4IStKz2i
8A/DFDu1Cvje0cWL6sBhSfZeG7yOu/+dSR8dzKa+6eOymSyvBCqsXu/Txtc604meM8KPBcMJVktg
Y0tNfVUKa8oeo5ISwViIw1ICrFq5vD3NjjRkyKrzHPnlh8IBGfxUt/fm6wo/i/BvdW1K9XzvdNh3
MoCC
--00000000000018857f05dc73894e--
