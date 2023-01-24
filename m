Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 143606793B9
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 10:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbjAXJMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 04:12:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjAXJMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 04:12:48 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9450D12045
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 01:12:47 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id p24so14087691plw.11
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 01:12:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QLQL4gCpHC0kKzNvMRs2N/41FUqryRLn4qN2pklf5uo=;
        b=gILk6HXVDEewx1xK2rEVicnQG7bwswvwUDGXY2dyumtELfZWIjyCF+LBauPdJNL8Lk
         GZ5u8TTxMQpub5EX7epPzS4I4kKDro+MNEih2vpFc2QxSzQ6M+uCAKoHSAaoWxBHiEN7
         Mdl0rLs23As6VtodBnXuuobIfQiQqQnCNfZfE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QLQL4gCpHC0kKzNvMRs2N/41FUqryRLn4qN2pklf5uo=;
        b=tKY013AOuvs51XAe32nFROuqjkKJlHAN5X0RBTPcsTOitkxjMqheeWusWALfLL+wn0
         orTWzem9OUk8opwZ8ZSSiAxKS0V6Q5ZpPUg6JkwUe8ggP+bM4zF1SkJKY1oRvFYI30dH
         bA8R08NAaB3Hdt4ZmVB6LNwkPD1tAO1QrDs4ahrST+hr+YG1FIBcPe5+FJBnYB2R5WLh
         XhdEWRdFWx0BjE0rpLXXk1SrMRIoR5r6h+s94Hf/FEuBYSBoVlQMhujWX+xwVgG40BGQ
         LTMso8OQDfDjebIDrdyVlDw4lob5SXRvsQ9Hs6OYE1J5KVEGNtSQISCJiFq5sZP6k5bn
         BbAQ==
X-Gm-Message-State: AFqh2krRzP1tkLgV4cCFVceH9bJ6JKFCvSkafmqkW5UVhxLLQzAhLyJp
        CuxahuxM/3A9qGflOxDj7tfPFm0MMlxm8at4c9jMzg==
X-Google-Smtp-Source: AMrXdXsaZt0e5hCLZrMI6mxbVZHj976M9pNkVRTqW2GtwT4ZLzwUelgDZrpGFC8u2zkQhm1Fk/0wb/5HZS0d3BIftaY=
X-Received: by 2002:a17:90a:5b0c:b0:223:fa07:7bfb with SMTP id
 o12-20020a17090a5b0c00b00223fa077bfbmr3106823pji.38.1674551567001; Tue, 24
 Jan 2023 01:12:47 -0800 (PST)
MIME-Version: 1.0
References: <20230124003107.214307-1-drc@linux.vnet.ibm.com>
 <CALs4sv1OYthkDYBbj9i-jytWo7VZ2rL9VcHiWP55svVX8R20RQ@mail.gmail.com> <CACKFLikyHar-H46VvN1cgTubdw88nQyh7pJ=zUq0V=kWx8CoVg@mail.gmail.com>
In-Reply-To: <CACKFLikyHar-H46VvN1cgTubdw88nQyh7pJ=zUq0V=kWx8CoVg@mail.gmail.com>
From:   Pavan Chebbi <pavan.chebbi@broadcom.com>
Date:   Tue, 24 Jan 2023 14:42:35 +0530
Message-ID: <CALs4sv3kA96-bfgR5VW967cKsW6z2Q1Y=ZMMomQDNT5_7jSWeg@mail.gmail.com>
Subject: Re: [PATCH] net/tg3: resolve deadlock in tg3_reset_task() during EEH
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     David Christensen <drc@linux.vnet.ibm.com>, netdev@vger.kernel.org,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000054bfbe05f2feeb0f"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000054bfbe05f2feeb0f
Content-Type: text/plain; charset="UTF-8"

On Tue, Jan 24, 2023 at 2:13 PM Michael Chan <michael.chan@broadcom.com> wrote:
>
> On Mon, Jan 23, 2023 at 11:25 PM Pavan Chebbi <pavan.chebbi@broadcom.com> wrote:
> >
> > On Tue, Jan 24, 2023 at 6:01 AM David Christensen
> > <drc@linux.vnet.ibm.com> wrote:
> > >
> > >
> > > diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
> > > index 59debdc344a5..ee4604e6900e 100644
> > > --- a/drivers/net/ethernet/broadcom/tg3.c
> > > +++ b/drivers/net/ethernet/broadcom/tg3.c
> > > @@ -11166,7 +11166,8 @@ static void tg3_reset_task(struct work_struct *work)
> > >         rtnl_lock();
> > >         tg3_full_lock(tp, 0);
> > >
> > > -       if (!netif_running(tp->dev)) {
> > > +       // Skip reset task if no netdev or already in PCI recovery
> > > +       if (!tp->dev || tp->pcierr_recovery || !netif_running(tp->dev)) {
> >
> > Thanks for the patch. Can we not use netif_device_present() here?
>
> Take a look at the beginning of tg3_io_error_detected().  I think he
> is trying to follow the same recipe there.  Basically, if a PCIe AER
> has already been detected, then let it finish and do nothing here.
>

Agree. Just that tg3_io_error_detected() will have done a
netif_device_detach() earlier, I thought it may be a simpler check.
Fine with this as well. The submitter may choose to re-spin to remove
the tp->dev check otherwise looks good to me.
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>

> I don't think the tp->dev check is needed though.  We always call
> tg3_reset_task_cancel() before we call unregister_netdev() and
> free_netdev().
>
> >
> > >                 tg3_flag_clear(tp, RESET_TASK_PENDING);
> > >                 tg3_full_unlock(tp);
> > >                 rtnl_unlock();
> > > @@ -18101,6 +18102,9 @@ static pci_ers_result_t tg3_io_error_detected(struct pci_dev *pdev,
> > >
> > >         netdev_info(netdev, "PCI I/O error detected\n");
> > >
> > > +       /* Want to make sure that the reset task doesn't run */
> > > +       tg3_reset_task_cancel(tp);
> > > +
> > >         rtnl_lock();
> > >
> > >         /* Could be second call or maybe we don't have netdev yet */
> > > @@ -18117,9 +18121,6 @@ static pci_ers_result_t tg3_io_error_detected(struct pci_dev *pdev,
> > >
> > >         tg3_timer_stop(tp);
> > >
> > > -       /* Want to make sure that the reset task doesn't run */
> > > -       tg3_reset_task_cancel(tp);
> > > -
> > >         netif_device_detach(netdev);
> > >
> > >         /* Clean up software state, even if MMIO is blocked */
> > > --
> > > 2.31.1
> > >

--00000000000054bfbe05f2feeb0f
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIBennNHoK/nNNmF0n3ieEI9daWu7IQ91
fr5bqr6eNijxMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDEy
NDA5MTI0N1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBc5n2LGQ4jK8awCBf0lgq9u0ACKNdYPLGAOkKUlGZBIEFsvTSy
Be9J2ON+GNMwyHxdwrRkOBN7aqrNkED4ajRse1HrRh7+Wl3TZHM4qIuI7rjY79wrdW94icKOM/Ba
izQ1fj+vJwVVveefyTGpiODkEXzHTHn3x9FEr7GEmo9uajX3mGksrmMoJRM+Fwyb8kS3/13ojplx
jxO6gfUzHBAlJ56pzr4cnRge9NMJKLcRBI02vyvFHOmgV123llT+pAqFAPpVx8H4q9J4B8tA3RUP
T2LKEWcik7qu0Z5anUPdPCM4NMzoG5BsbVANRwSr2tt49JAhnrUBjpP3EW6BLTe5
--00000000000054bfbe05f2feeb0f--
