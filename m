Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728E24DCCBD
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 18:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237037AbiCQRrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 13:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235157AbiCQRrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 13:47:04 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBAF12E774
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 10:45:47 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id h11so8243581ljb.2
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 10:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zHshqBWGJ/SV2YPbuPDFrgx/gOxOVu0NYFvOIDDz6P8=;
        b=NjJ2cVELZgj39GRzHgeM+sRMfylN6RWqK2oK19xM0xuxDADvtdbX+32HbF3ut3azsr
         Mxynv9/QFhUo5Tq41WPnSD/HKZECZOb702TUT/wBQZ05zJnIRKNa8znXzuGztlKITnol
         5dCxB+5dPF28RRzsFKyqYBVLeO+ghASW5/j7o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zHshqBWGJ/SV2YPbuPDFrgx/gOxOVu0NYFvOIDDz6P8=;
        b=DHLmIJoHEKvu95oLRm7L0gl/sVf2j8T291eH/sh50+1w6krrfC2zyzKtzV3fL0P39S
         PiZEZgGnuD6VP/DVTaHcyY9YRERjuOA34oMimW4gUps654JvlidhPAMQgZB92BoFuNzR
         qyfKlEEg53uy8lg+L6M6cJwCsK81KoaVrqqqGOIifsAYGCPWRUlwavPNVwY65SIiFZVs
         xbog1AW3y9xNrgiTAsEdhzHmSsyChhhRsc9bikLzVObEwOwAIAX6kt7RridbF7Q7QGSQ
         XiJJxpLQxqWlif9Cvav4GcVEoUJ/JTqSwX/fPUiAZ127Q1TR51OGAmauOmmZb9LZmL0p
         eFRw==
X-Gm-Message-State: AOAM530q6ibCfFaM1CXCt8b48A2LPf6asFNK9FpJ1z9NWqWdnfmJe3YY
        dWkSQJAqnuWSJC9tQFFcyQ8HROKGtEIuZBOT698NsmLiBH4jBlgSWE66NyhJqr36mtGm6/K/chH
        LLkRcqOWrc9zFwHOxTo4iP4j6Pj8E
X-Google-Smtp-Source: ABdhPJx/XoBGzoRzEMvFTkOjgznxoXdebxaXqXsLsAy3lDMkOusiRwBYobSj99V27eidgpMcj6M3ZBrwOqlxKFYek14=
X-Received: by 2002:a05:651c:543:b0:247:e3b1:9ac3 with SMTP id
 q3-20020a05651c054300b00247e3b19ac3mr3697910ljp.438.1647539145240; Thu, 17
 Mar 2022 10:45:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220317042023.1470039-1-kuba@kernel.org> <20220317042023.1470039-2-kuba@kernel.org>
 <CACKFLi=O4ffBLgP=Xi_CFzwpFVc+zGRH4pmZ15h_YP-imzNpvw@mail.gmail.com>
In-Reply-To: <CACKFLi=O4ffBLgP=Xi_CFzwpFVc+zGRH4pmZ15h_YP-imzNpvw@mail.gmail.com>
From:   Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Date:   Thu, 17 Mar 2022 23:15:33 +0530
Message-ID: <CAHHeUGU5Ppkj+YgCnfkGMzsF_2hUcKeemSqk5_PZreC535EgNg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/5] bnxt: use the devlink instance lock to
 protect sriov
To:     netdev@vger.kernel.org,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        leonro@nvidia.com, saeedm@nvidia.com, idosch@idosch.org,
        Michael Chan <michael.chan@broadcom.com>,
        simon.horman@corigine.com, kuba@kernel.org
Cc:     Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000088b4f205da6d99da"
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000088b4f205da6d99da
Content-Type: text/plain; charset="UTF-8"

>
>
> In prep for .eswitch_mode_set being called with the devlink instance
> lock held use that lock explicitly instead of creating a local mutex
> just for the sriov reconfig.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c       | 1 -
>  drivers/net/ethernet/broadcom/bnxt/bnxt.h       | 6 ------
>  drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c | 4 ++--
>  drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c   | 4 ++--
>  4 files changed, 4 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> index 92a1a43b3bee..1c28495875cf 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -13470,7 +13470,6 @@ static int bnxt_init_one(struct pci_dev *pdev,
> const struct pci_device_id *ent)
>
>  #ifdef CONFIG_BNXT_SRIOV
>         init_waitqueue_head(&bp->sriov_cfg_wait);
> -       mutex_init(&bp->sriov_lock);
>  #endif
>         if (BNXT_SUPPORTS_TPA(bp)) {
>                 bp->gro_func = bnxt_gro_func_5730x;
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> index 447a9406b8a2..61aa3e8c5952 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> @@ -2072,12 +2072,6 @@ struct bnxt {
>         wait_queue_head_t       sriov_cfg_wait;
>         bool                    sriov_cfg;
>  #define BNXT_SRIOV_CFG_WAIT_TMO        msecs_to_jiffies(10000)
> -
> -       /* lock to protect VF-rep creation/cleanup via
> -        * multiple paths such as ->sriov_configure() and
> -        * devlink ->eswitch_mode_set()
> -        */
> -       struct mutex            sriov_lock;
>  #endif
>
>  #if BITS_PER_LONG == 32
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
> b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
> index 1d177fed44a6..ddf2f3963abe 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c
> @@ -846,7 +846,7 @@ void bnxt_sriov_disable(struct bnxt *bp)
>                 return;
>
>         /* synchronize VF and VF-rep create and destroy */
> -       mutex_lock(&bp->sriov_lock);
> +       devl_lock(bp->dl);
>         bnxt_vf_reps_destroy(bp);
>
>         if (pci_vfs_assigned(bp->pdev)) {
> @@ -859,7 +859,7 @@ void bnxt_sriov_disable(struct bnxt *bp)
>                 /* Free the HW resources reserved for various VF's */
>                 bnxt_hwrm_func_vf_resource_free(bp, num_vfs);
>         }
> -       mutex_unlock(&bp->sriov_lock);
> +       devl_unlock(bp->dl);
>
>         bnxt_free_vf_resources(bp);
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
> b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
> index 8eb28e088582..b2a9528b456b 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
> @@ -561,7 +561,7 @@ int bnxt_dl_eswitch_mode_set(struct devlink
> *devlink, u16 mode,
>         struct bnxt *bp = bnxt_get_bp_from_dl(devlink);
>         int rc = 0;
>
> -       mutex_lock(&bp->sriov_lock);
> +       devl_lock(devlink);
>         if (bp->eswitch_mode == mode) {
>                 netdev_info(bp->dev, "already in %s eswitch mode\n",
>                             mode == DEVLINK_ESWITCH_MODE_LEGACY ?
> @@ -595,7 +595,7 @@ int bnxt_dl_eswitch_mode_set(struct devlink
> *devlink, u16 mode,
>                 goto done;
>         }
>  done:
> -       mutex_unlock(&bp->sriov_lock);
> +       devl_unlock(devlink);
>         return rc;
>  }
>
> --
> 2.34.1

Hi Jakub,

The changes look good to me overall. But I have a few concerns. This
change introduces a lock that is held across modules and if there's
any upcall from the driver into devlink that might potentially acquire
the same lock, then it could result in a deadlock. I'm not familiar
with the internals of devlink, but just want to make sure this point
is considered. Also, the driver needs to be aware of this lock and use
it in new code paths within the driver to synchronize with switchdev
operations. This may not be so obvious when compared to a driver
private lock.

Thanks,
-Harsha

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

--00000000000088b4f205da6d99da
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
MSIEIGRs9qSYrmU+wbkjuE3naMCjcnMo5j1Wo3J6DCNvsfvLMBgGCSqGSIb3DQEJAzELBgkqhkiG
9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDMxNzE3NDU0NVowaQYJKoZIhvcNAQkPMVwwWjALBglg
hkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0B
AQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCcsuNvOL5M/XlS
Jc6ixMcjsUXXQEvlN8Aklvgo9XuFYMB8zffoAlzff5NS6nsdclR8etlblfSijq7Gxr0SNraUmeyT
1up3rq/IgCR+CrP9diWWph+e5kGwlUq6yeaMwgPq1n3sLFXAPs2INjhtRGt0kC3lyX2JChYpDHt6
iMAJ/fGfM1XKx9KfhPND2oG2Cn/gFtjuDHrlqlrV0DYn27iaFLHttXtM9av8157THtmao39JCY7g
SwDXkvh4Kb//jGEBvYwP1qRs3Et3nQ70OliM7IxTEyCUumnzOTTGRMGJ5yGr6/HGQZj6Aq7jIy6m
NEWkp254FoCyrCl1Fm1UpwBQ
--00000000000088b4f205da6d99da--
