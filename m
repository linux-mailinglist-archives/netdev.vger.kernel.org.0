Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23B9E6B2408
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 13:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjCIMXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 07:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjCIMXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 07:23:16 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56BE5678A
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 04:23:13 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id ce8-20020a17090aff0800b0023a61cff2c6so5907606pjb.0
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 04:23:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1678364593;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zak6MgxG7QeeO/wIRFRs3dKeWuRAL5INiNptxhMQDhI=;
        b=Sg0ui0YvQ21BFyIJIU0vdOpYKGh/UN7YpTU6BbMPyZjnOnh+WNzSMbheyonHBgr2OX
         JJloLd/2pK5ZDt3mC4LFNMc6xOkv1jLisFAdcQ7kHvmVbBGzs0fScYdgTMwgYLeKaXnY
         m+V2YEEMPGE2vkI8TTTtTOOUuJLECzHFKVrjk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678364593;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zak6MgxG7QeeO/wIRFRs3dKeWuRAL5INiNptxhMQDhI=;
        b=h386LNVQJuH02G863yKhWPgDY9qjqiY9RkgPsEqYGPzlTA1k+zFqq87SIOykzxAOZp
         FLcdJaE/3PBpwV2GqQlIKN7f0gBKzcBWLoF9GLvbZNakwXq75/3BC45ZBNVtsqHc2MO0
         edSlhrUCcl8/MHqzjja9OhCcHeZZtwxqBzpmbT0eRIxt/X14p0vCbPxNLpm6OL6xKWEp
         OfynTUKDlII7gM/ou7+MclPUPqR8fAxeKh4/b74NpXHy9H28W5cPzdUxFVt2UGkdVNlj
         rB1Lqe+IYlR7oXwIEfDLxAq/C09bgFZ37uZhiLcdFY2molPz3ZZ8jTlcfPcNahlAECM9
         tRiA==
X-Gm-Message-State: AO0yUKVoL9wAxvbsXMIQJbI8jAprNkfpWf6fCHrREfCxjmVK2pV9tKJC
        /511Au1sPMuQoyHaadNxiSiSdpBVZj4PbyIY8XFSIg==
X-Google-Smtp-Source: AK7set+L3b2UYeNNhLMkwOuUNd2E+NoZcbA/vASkg9f2XmvAmD/6NruSJ1t2Proxm44IOBoj5rONu45hhQqpyQXGBDw=
X-Received: by 2002:a17:903:41d0:b0:199:21af:cb86 with SMTP id
 u16-20020a17090341d000b0019921afcb86mr11337935ple.4.1678364593159; Thu, 09
 Mar 2023 04:23:13 -0800 (PST)
MIME-Version: 1.0
References: <20230308144209.150456-1-vadfed@meta.com> <CALs4sv3+jKGA=z-Nb1akw2h1jkL6T7VLj4pV7KVsZwx1Gt+DnA@mail.gmail.com>
 <38521144-ddc0-f11b-8243-636de48d0c11@linux.dev> <CALs4sv2cOFEVFwJ_UgV5T0iJOAzM7X=jvDqsdAtjiuQjTs5U8g@mail.gmail.com>
 <a2e3f3d3-f53c-d270-0495-e67624c3db96@linux.dev>
In-Reply-To: <a2e3f3d3-f53c-d270-0495-e67624c3db96@linux.dev>
From:   Pavan Chebbi <pavan.chebbi@broadcom.com>
Date:   Thu, 9 Mar 2023 17:53:02 +0530
Message-ID: <CALs4sv3f=oYVW3d8nu440zaVUxGOmMuKWN3VKm24PvhSWu8hcw@mail.gmail.com>
Subject: Re: [PATCH net v2] bnxt_en: reset PHC frequency in free-running mode
To:     Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc:     Vadim Fedorenko <vadfed@meta.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000680e7505f676b557"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000680e7505f676b557
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 9, 2023 at 4:20=E2=80=AFPM Vadim Fedorenko
<vadim.fedorenko@linux.dev> wrote:
>
> On 09/03/2023 10:11, Pavan Chebbi wrote:
> > On Thu, Mar 9, 2023 at 3:02=E2=80=AFPM Vadim Fedorenko
> > <vadim.fedorenko@linux.dev> wrote:
> >>
> >> On 09.03.2023 04:40, Pavan Chebbi wrote:
> >>> On Wed, Mar 8, 2023 at 8:12=E2=80=AFPM Vadim Fedorenko <vadfed@meta.c=
om> wrote:
> >
> >>>> @@ -932,13 +937,15 @@ int bnxt_ptp_init(struct bnxt *bp, bool phc_cf=
g)
> >>>>           atomic_set(&ptp->tx_avail, BNXT_MAX_TX_TS);
> >>>>           spin_lock_init(&ptp->ptp_lock);
> >>>>
> >>>> -       if (bp->fw_cap & BNXT_FW_CAP_PTP_RTC) {
> >>>> +       if (BNXT_PTP_USE_RTC(ptp->bp)) {
> >>>>                   bnxt_ptp_timecounter_init(bp, false);
> >>>>                   rc =3D bnxt_ptp_init_rtc(bp, phc_cfg);
> >>>>                   if (rc)
> >>>>                           goto out;
> >>>>           } else {
> >>>>                   bnxt_ptp_timecounter_init(bp, true);
> >>>> +               if (bp->fw_cap & BNXT_FW_CAP_PTP_RTC)
> >>>
> >>> I understand from your response on v1 as to why it will not affect yo=
u
> >>> if a new firmware does not report RTC on MH.
> >>> However, once you update the fw, any subsequent kernels upgrades will
> >>> prevent resetting the freq stored in the PHC.
> >>> Would changing the check to if (BNXT_MH(bp)) instead be a better opti=
on?
> >>
> >> How will it affect hardware without RTC support? The one which doesn't=
 have
> >> BNXT_FW_CAP_PTP_RTC in a single-host configuration. Asking because if =
FW will
> >
> > For single hosts, it should not matter if we reset the PHC frequency.
> > bnxt_ptp_init() is [re]initializing the host-timecounter, and this
> > function being called on a single host means everything is going to
> > [re]start from scratch.
> >
> >> not expose BNXT_FW_CAP_PTP_RTC, the check BNXT_PTP_USE_RTC() will be e=
qual to
> >> !BNXT_MH() and there will be no need for additional check in this else=
 clause.
> >
> > You are right, hence my original suggestion of resetting the PHC freq
> > unconditionally is better.
> > One more thing, the function bnxt_ptp_adjfine() should select
> > non-realtime adjustments only for MH systems.
> > You may need to flip the check, something like
> >
> > if (!BNXT_MH(ptp->bp))
> >      return bnxt_ptp_adjfine_rtc(bp, scaled_ppm);
> >
> > This is because there can be a very old firmware which does not have
> > RTC on single hosts but we still want to make HW adjustments.
>
> Well, I just want to be sure that we will support all possible
> combinations of FW in the driver. AFAIU, there 3 different options:
>
> 1. Very old firmware. Doesn't have RTC support and doesn't expose
> BNXT_FW_CAP_PTP_RTC. Call to bnxt_ptp_adjfine_rtc on this variant may
> make HW unusable. We MUST not call it in this case. The timecounter is
> also not supported in this configuration, right?

No, the first ever version of bnxt PTP solution has the FW support for
HW adjustment but does not expose BNXT_FW_CAP_PTP_RTC.
So we need to be mindful of this just to keep backward compatibility intact=
.

> 2. Firmware which supports RTC and exposes BNXT_FW_CAP_PTP_RTC.
> Timecounter should be used only in MH case then.

Timecounter is used in all variations. Single host (SH) and Multi host
(MH), with/without RTC. The only difference is how timecounter is
used.
With RTC, we wanted to provide an MH solution to achieve
synchronization across all the hosts using a common timebase.
But we had to implement the recently added non-realtime design to
achieve that goal. But we still need RTC on single hosts when we want
to adjust phase.

> 3. Firmware which supports RTC, but doesn't expose BNXT_FW_CAP_PTP_RTC
> for MH configuration. How can we understand that it's not variant 1 in
> MH configuration? Or are we sure FUNC_QCAPS_RESP_FLAGS_PTP_SUPPORTED is
> not set on old firmware?

As such we don't use RTC (even if exposed) at all in MH case. So
simply ignore the RTC if you determine a MH system.

Let me just summarize:
we can have three variants of Firmware.
1. That does not have RTC exposed on both SH and MH (very old)
2. That has RTC exposed both on SH and MH (current production)
3. That has RTC exposed on SH and not on MH (future)

In all the above cases, we make use of the timecounter for timestamps,
but we must make HW freq adjustments in SH, and timecounter freq
adjustments in MH.

--000000000000680e7505f676b557
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
OltyqaGBuzv+bJTUL+bmV7E4QBLIqGt4jVr1R9hJdH6KxXwJdyfHZ9C6qXmoe2NQhiFUyBOJ0wgk
dB9Z1IU7nCwvNKYg2JMoJs93tIgbhPJg/D7pqW8gabkCAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZcGF2YW4uY2hlYmJpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUEV6y/89alKPoFbKUaJXsvWu5
fdowDQYJKoZIhvcNAQELBQADggEBAEHSIB6g652wVb+r2YCmfHW47Jo+5TuCBD99Hla8PYhaWGkd
9HIyD3NPhb6Vb6vtMWJW4MFGQF42xYRrAS4LZj072DuMotr79rI09pbOiWg0FlRRFt6R9vgUgebu
pWSH7kmwVXcPtY94XSMMak4b7RSKig2mKbHDpD4bC7eGlwl5RxzYkgrHtMNRmHmQor5Nvqe52cFJ
25Azqtwvjt5nbrEd81iBmboNTEnLaKuxbbCtLaMEP8xKeDjAKnNOqHUMps0AsQT8c0EGq39YHpjp
Wn1l67VU0rMShbEFsiUf9WYgE677oinpdm0t2mdCjxr35tryxptoTZXKHDxr/Yy6l6ExggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwV/XkICjVscn4SNZMw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIBqloNonbYxWBglFjMnZ5xFuGwnjwGA6
6YMnMLBcP1qeMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDMw
OTEyMjMxM1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQApfIvA4eO2CBGTs7HYuKRS7sHGzSMJL1/SLuOM25HkMSe8jSSt
E9BJkj7iT/hbZ1y8SHWS8sXbSjuByX1AyroGkr06pVQQacE6jiovkppRjdQWrkZVtf0E8XHdZGTo
oq3o/ellX/O3xV5N0nwwLbyEuMJQdVUBmy9y8eC0xs7jgEHoYTyy+4D4JofbGxjYfGIda++qX9dJ
Oj2Y4VFe5va/1lmTyv/BcrjJtRl4DV3/Q9JaqNEXIW3QIcKwoDmwDthPvm3nNnelY0BeRjbBM9/f
5nDO8tAdiobBiMDAAEePn9brWJ3+ga7t/AILOdNMNlibIhLGR2T4MbLcjtCTIlPj
--000000000000680e7505f676b557--
