Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B60F24DCED0
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 20:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236294AbiCQT0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 15:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232122AbiCQT0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 15:26:00 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C663DA146A
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 12:24:43 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id o64so6642438oib.7
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 12:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=asX/EfEQCEASuwixRik5XD8BSZEEfpjviJ1gyk93Qv0=;
        b=XDsdxdijB85TGHzeSx4S700wqcd5jHVnIdI3PGB9WlCAZX/JCzkGWRISitYt/l6agO
         XH/GsR4sWaF1voCoXHDKDx0kBj6kcNbPt9spL/WHuRB2rYfWb/xAU9f/SWCwSKuVUXbM
         1zjPJiFRiWWKt7UQqBkVC+lMDoxJhp3w4cE4w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=asX/EfEQCEASuwixRik5XD8BSZEEfpjviJ1gyk93Qv0=;
        b=Hi5gaw1fHcKWc1LvMfGmQXzI+A9yP7Kylj/9+RinYqqAf1+5/Z2hTYDpMgs+/wAiSZ
         DP3MRF07MxvJUiOWdixPGUb29C326vnjnP0Jo3qKIGhqndunKfLtnhuPEeU0i7lxVqeV
         c1AYsTg/v+/9pjIDflOSMt1pQ7TUwMEprA9NnUzrpjRgcnIjwcqgKdRcRQM5/MjqAoR/
         V0SEjE4pZ1weInyy/DdFlnWLPbR05gfeUAxMqlCnenLRhP3ACdiOn/vYYDNduWBSb8G2
         a3B2F9fReQETftA3w5kkBTJU2QnBlzL7RyvZF7qR9IIjC7ihznXr2Uxi/jLEhJwSMXtW
         2iWw==
X-Gm-Message-State: AOAM530pBDP8sB9G9RMys6WZPu43qArVrawGNefo89bP2eJvk+Ec5rme
        igegne2fXUgnZexw1om0+bbddj0aJWzLAKzTeGtUw7J34WuNSCF8VFo9IwDA+psTxTYSmFwY4Fn
        32GCil2kn+JITHAoOIrt1Tik=
X-Google-Smtp-Source: ABdhPJyOsZgVb3PYJ4vGYMLn9T/Dv2y5UIAn9KY+7CFPq9OloPfowq5uABX3fQ3mHqHI3KSwrJn+Sj4ivWQWkjHtnB4=
X-Received: by 2002:a05:6808:47:b0:2ec:bddc:c677 with SMTP id
 v7-20020a056808004700b002ecbddcc677mr6428182oic.250.1647545083044; Thu, 17
 Mar 2022 12:24:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220317042023.1470039-1-kuba@kernel.org> <20220317042023.1470039-2-kuba@kernel.org>
 <CACKFLi=O4ffBLgP=Xi_CFzwpFVc+zGRH4pmZ15h_YP-imzNpvw@mail.gmail.com>
 <CAHHeUGU5Ppkj+YgCnfkGMzsF_2hUcKeemSqk5_PZreC535EgNg@mail.gmail.com> <20220317111959.7cad8fb1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220317111959.7cad8fb1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Date:   Fri, 18 Mar 2022 00:54:31 +0530
Message-ID: <CAHHeUGVA2UodrRCYOwy-yinjyhU8geepmZKKwtcu75zO+tyxfA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/5] bnxt: use the devlink instance lock to
 protect sriov
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        leonro@nvidia.com, saeedm@nvidia.com, idosch@idosch.org,
        Michael Chan <michael.chan@broadcom.com>,
        simon.horman@corigine.com,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000725efc05da6efbfb"
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000725efc05da6efbfb
Content-Type: text/plain; charset="UTF-8"

On Thu, Mar 17, 2022 at 11:50 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 17 Mar 2022 23:15:33 +0530 Sriharsha Basavapatna wrote:
> > The changes look good to me overall. But I have a few concerns. This
> > change introduces a lock that is held across modules and if there's
> > any upcall from the driver into devlink that might potentially acquire
> > the same lock, then it could result in a deadlock. I'm not familiar
> > with the internals of devlink, but just want to make sure this point
> > is considered. Also, the driver needs to be aware of this lock and use
> > it in new code paths within the driver to synchronize with switchdev
> > operations. This may not be so obvious when compared to a driver
> > private lock.
>
> That's true, that's why we're adding the new "unlocked" devl_* API.
> I'm switching the drivers accordingly, I didn't see any upcalls in
> the relevant parts in bnxt, LMK if I missed something!

There's no upcall currently at least in switchdev related code in bnxt.

-- 
This electronic communication and the information and any files transmitted 
with it, or attached to it, are confidential and are intended solely for 
the use of the individual or entity to whom it is addressed and may contain 
information that is confidential, legally privileged, protected by privacy 
laws, or otherwise restricted from disclosure to anyone else. If you are 
not the intended recipient or the person responsible for delivering the 
e-mail to the intended recipient, you are hereby notified that any use, 
copying, distributing, dissemination, forwarding, printing, or copying of 
this e-mail is strictly prohibited. If you received this e-mail in error, 
please return the e-mail to the sender, delete it from your computer, and 
destroy any printed copy of it.

--000000000000725efc05da6efbfb
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQiAYJKoZIhvcNAQcCoIIQeTCCEHUCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3fMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA5MTYwMDAwMDBaFw0yODA5MTYwMDAwMDBaMFsxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBS
MyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
vbCmXCcsbZ/a0fRIQMBxp4gJnnyeneFYpEtNydrZZ+GeKSMdHiDgXD1UnRSIudKo+moQ6YlCOu4t
rVWO/EiXfYnK7zeop26ry1RpKtogB7/O115zultAz64ydQYLe+a1e/czkALg3sgTcOOcFZTXk38e
aqsXsipoX1vsNurqPtnC27TWsA7pk4uKXscFjkeUE8JZu9BDKaswZygxBOPBQBwrA5+20Wxlk6k1
e6EKaaNaNZUy30q3ArEf30ZDpXyfCtiXnupjSK8WU2cK4qsEtj09JS4+mhi0CTCrCnXAzum3tgcH
cHRg0prcSzzEUDQWoFxyuqwiwhHu3sPQNmFOMwIDAQABo4IB2jCCAdYwDgYDVR0PAQH/BAQDAgGG
MGAGA1UdJQRZMFcGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAgYKKwYBBAGCNwoDBAYJ
KwYBBAGCNxUGBgorBgEEAYI3CgMMBggrBgEFBQcDBwYIKwYBBQUHAxEwEgYDVR0TAQH/BAgwBgEB
/wIBADAdBgNVHQ4EFgQUljPR5lgXWzR1ioFWZNW+SN6hj88wHwYDVR0jBBgwFoAUj/BLf6guRSSu
TVD6Y5qL3uLdG7wwegYIKwYBBQUHAQEEbjBsMC0GCCsGAQUFBzABhiFodHRwOi8vb2NzcC5nbG9i
YWxzaWduLmNvbS9yb290cjMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5j
b20vY2FjZXJ0L3Jvb3QtcjMuY3J0MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vcm9vdC1yMy5jcmwwWgYDVR0gBFMwUTALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgEo
CjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAN
BgkqhkiG9w0BAQsFAAOCAQEAdAXk/XCnDeAOd9nNEUvWPxblOQ/5o/q6OIeTYvoEvUUi2qHUOtbf
jBGdTptFsXXe4RgjVF9b6DuizgYfy+cILmvi5hfk3Iq8MAZsgtW+A/otQsJvK2wRatLE61RbzkX8
9/OXEZ1zT7t/q2RiJqzpvV8NChxIj+P7WTtepPm9AIj0Keue+gS2qvzAZAY34ZZeRHgA7g5O4TPJ
/oTd+4rgiU++wLDlcZYd/slFkaT3xg4qWDepEMjT4T1qFOQIL+ijUArYS4owpPg9NISTKa1qqKWJ
jFoyms0d0GwOniIIbBvhI2MJ7BSY9MYtWVT5jJO3tsVHwj4cp92CSFuGwunFMzCCA18wggJHoAMC
AQICCwQAAAAAASFYUwiiMA0GCSqGSIb3DQEBCwUAMEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24gUm9v
dCBDQSAtIFIzMRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTA5
MDMxODEwMDAwMFoXDTI5MDMxODEwMDAwMFowTDEgMB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENB
IC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMJXaQeQZ4Ihb1wIO2hMoonv0FdhHFrYhy/EYCQ8eyip0E
XyTLLkvhYIJG4VKrDIFHcGzdZNHr9SyjD4I9DCuul9e2FIYQebs7E4B3jAjhSdJqYi8fXvqWaN+J
J5U4nwbXPsnLJlkNc96wyOkmDoMVxu9bi9IEYMpJpij2aTv2y8gokeWdimFXN6x0FNx04Druci8u
nPvQu7/1PQDhBjPogiuuU6Y6FnOM3UEOIDrAtKeh6bJPkC4yYOlXy7kEkmho5TgmYHWyn3f/kRTv
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBWcwggRPoAMCAQICDHwPOVVHl1xko7arzjANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxNDIwMDBaFw0yMjA5MjIxNDUzNDZaMIGg
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xHjAcBgNVBAMTFVNyaWhhcnNoYSBCYXNhdmFwYXRuYTExMC8G
CSqGSIb3DQEJARYic3JpaGFyc2hhLmJhc2F2YXBhdG5hQGJyb2FkY29tLmNvbTCCASIwDQYJKoZI
hvcNAQEBBQADggEPADCCAQoCggEBANPB6e2ecGIzq17ATbtSoNTcXs3+3KxQtJrNDKkNrObMJp/b
VakVcchCETCMmJftnC3FjsVElVAg9WIJLt3KnGDZAzSsLyxCHI9SXo5+RlBf+hv1zfcBe67ReEmJ
QknQwUMcKk5UzdF9hFK7V3pBvmOa6roe8kxfNIjLnLVAs1TAsWsdQRhkn9XHPxmSlXI+jIgBlgEp
n4cHM9kULWou6X82i6YpNgk6jcy3RbH/5CZi2ma0trXNxG1AT5PU7lQHtDlpZUFzMJrdpxcZAGme
OWPVVc2Vqo/UjFeRyb85PywwGEI6DD0kN+JCXXvNFYSrP5+OLfYuYzZn/P0dhTlpVBECAwEAAaOC
AeMwggHfMA4GA1UdDwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0
dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2Ey
MDIwLmNydDBBBggrBgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3Bl
cnNvbmFsc2lnbjJjYTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEW
Jmh0dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0f
BEIwQDA+oDygOoY4aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMC5jcmwwLQYDVR0RBCYwJIEic3JpaGFyc2hhLmJhc2F2YXBhdG5hQGJyb2FkY29tLmNv
bTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAd
BgNVHQ4EFgQU4iyqaHpN7h0t+lm5ZP6dwo9UwSIwDQYJKoZIhvcNAQELBQADggEBAKesjSeypac1
qslWkfD+g52UNPe0MbS7zcqWwURf5yxzgNbMIbNhWneeVqxlk2gC5b7UnGbGS4hteg/PDKQJpSnu
Mrudx5Kj1a0DBtKbnsOg/BjSe8icKl1WJZU6Csxh6jBRMn2MkmmFIUejZLdfOJZs9USE1a8EVCc9
7WU4KWzYAfMupI62STY+35xBdioPjWMFpYS9k2stCCqXO0HjMDA6IYlftQTxOB9GHO6DggLtk5hW
tcixnNCu9VS7kminQ+ZQHcE7F7h7nwyN3NRS1krFg1or6JNvhHck/cJc/rLE9xkh3HzTk87hL5Rb
3N8pa3Us3las0xeybFAj7ss75GwxggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQK
ExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNp
Z24gMiBDQSAyMDIwAgx8DzlVR5dcZKO2q84wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkE
MSIEIJtmvkZgpleEMgLNPhhMynogFcdNSZ0+BtdWdRzvWLutMBgGCSqGSIb3DQEJAzELBgkqhkiG
9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDMxNzE5MjQ0M1owaQYJKoZIhvcNAQkPMVwwWjALBglg
hkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0B
AQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBjFq7ilfkaeXcY
SBYMMhTGvQ6oc5LVDp8ICHd4oB//ksiOkth2m5TTJNDcKkPlMlps/w/O20MZ2YqItoqUz1epup7k
mYKeY8Vqoq3K2FS9ZYdSg7xjEuJdPn1QR/u1ofyq7nzy/7kJutpr0Ov28p+3/VbTavJwkdsXBZvM
aOTSh1Fu6UWPp2t9oC8nr+7FWpP4JOMnZH+e+8VrYnwmbmNsJq68gG/8cfckDpcOAy8zeMykLPFW
UlcThgArr8ZUFXc6Mn2DPQ7NoGK5coF7IcJwMqVLbD3RI5TE6V+XZA3ds2AaGvYea6ZwObzErVq+
Dg1hVVSzjvPykDP8C2LofwYe
--000000000000725efc05da6efbfb--
