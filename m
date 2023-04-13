Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9736E0796
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 09:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjDMHVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 03:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjDMHVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 03:21:06 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D0459F4
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 00:21:01 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1681370459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Gf8o/adbOI2wRHyAYHOuUl4w2xDShw502p6uq1yjW/o=;
        b=jd0nFk877ojN78H+xnoNZJ21TJY8IunD0mL0OMSkHT8cJWKHhKCmjsXX1SZDtHp6OLzOZp
        NICA8IzoOwv7zD95uzyVTkDBmzx18xtGUPeNehe1RiPxbCqrnHuNaiW1zgsUpZOsMhihpm
        2ZTYF0YzDIuwhgmX+BstzaRDWE0w1WA+nM+mEIrhwpgeNgnbBSQiRjvCKEp3ygKClUMPlq
        K5uJftvEczJMAuN1U/U4sIGgzf/pEvTXBAg3Xk4/AMA7SzwSs2L6VQbv4jesLq2vYkX4iI
        /QHeBkApg8ydOjrkLzqp1rD0dWqlSlTfd8sFUwqs2iRqr3Oa6KaKh+3nb+OX6Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1681370459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Gf8o/adbOI2wRHyAYHOuUl4w2xDShw502p6uq1yjW/o=;
        b=55cEtF6OKAcYwqDBb/O/ndO9DLSWPvumJVkEmWH/bw0Mg3gePHry7BysvkfLRWfZsiUbcp
        geJacF7BdpyxHGAQ==
To:     Jacob Keller <jacob.e.keller@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] igc: Avoid transmit queue timeout for XDP
In-Reply-To: <1809a34d-dcf4-4b54-089a-a7be3f4c23e1@intel.com>
References: <20230412073611.62942-1-kurt@linutronix.de>
 <1809a34d-dcf4-4b54-089a-a7be3f4c23e1@intel.com>
Date:   Thu, 13 Apr 2023 09:20:57 +0200
Message-ID: <874jpk2qp2.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed Apr 12 2023, Jacob Keller wrote:
> On 4/12/2023 12:36 AM, Kurt Kanzenbach wrote:
>> High XDP load triggers the netdev watchdog:
>>=20
>> |NETDEV WATCHDOG: enp3s0 (igc): transmit queue 2 timed out
>>=20
>> The reason is the Tx queue transmission start (txq->trans_start) is not =
updated
>> in XDP code path. Therefore, add it for all XDP transmission functions.
>>=20
>> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
>
> For Intel, I only see this being done in igb, as 5337824f4dc4 ("net:
> annotate accesses to queue->trans_start"). I see a few other drivers
> also calling this.
>
> Is this a gap that other XDP implementations also need to fix?
>
> grepping for txq_trans_cond_update I see:
>
>> apm/xgene/xgene_enet_main.c
>> 874:            txq_trans_cond_update(txq);
>>=20
>> engleder/tsnep_main.c
>> 623:            txq_trans_cond_update(tx_nq);
>> 1660:           txq_trans_cond_update(nq);
>>=20
>> freescale/dpaa/dpaa_eth.c
>> 2347:   txq_trans_cond_update(txq);
>> 2553:   txq_trans_cond_update(txq);
>>=20
>> ibm/ibmvnic.c
>> 2485:   txq_trans_cond_update(txq);
>>=20
>> intel/igb/igb_main.c
>> 2980:   txq_trans_cond_update(nq);
>> 3014:   txq_trans_cond_update(nq);
>>=20
>> stmicro/stmmac/stmmac_main.c
>> 2428:   txq_trans_cond_update(nq);
>> 4808:   txq_trans_cond_update(nq);
>> 6436:   txq_trans_cond_update(nq);
>>=20
>
> Is most driver's XDP implementation broken? There's also
> netif_trans_update but this is called out as a legacy only function. Far
> more drivers call this but I don't see either call or a direct update to
> trans_start in many XDP implementations...
>
> Am I missing something or are a bunch of other XDP implementations also
> wrong?
>
> The patch seems ok to me, assuming this is the correct way to fix things
> and not something in the XDP path.

AFAICT the netdev watchdog is only started when the device exposes
ndo_tx_timeout callback (see __netdev_watchdog_up()). For igc this
callback was introduced recently in 9b275176270e ("igc: Add
ndo_tx_timeout support"). My guess, as soon as the net device has
ndo_tx_timeout it needs to maintain trans_start for XDP?

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmQ3rVkTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgibTD/0S41/87v4PI039H0WiQE3mh+bEA9rP
I8IbnifWL8hhJGedZBCucDwNuSsXADxiHrSLKVGdz0UjgFJExkMGrSEvBFrV0Zs4
MYuMTlw/wYTF4KN5YBYqkzCsIuzrl+yGdhtBDcuTaxl0YLzF6xUP7yALAtyZgY+1
+u15zKytCypI5FDB1VqfNiOc3kw6NtfvCxTZQwPuBC8ZP6jF+qrG0xI+ldnjnXl3
0qJyRQCdE7+cfY7/meuZRtipP6WLcOLjUofUnHVCnXmLituzWgY8ZS/nQA9yiEvU
Wo9OdTcUmof8R7cLKcQZbtf4v97CtAy6oYbONUHPDePcmDJhAO92fvmGty0GQH32
oBfOVCy2fzJ9lf4rjOKRmXYauCVtGmZDTAFcQakN1T+PXYdZku9RTp06I+JTKhgh
MPl7tyCYw4Vr576N9GLc928XIXB5WR1ADokAvgZ6zQtiVDKnM+az4MHmXfo4rHcG
BXm2zu4zQrC/DkW8CsfjcdCaloa62OlxthfD5kCkvh/Ew70E+DCJSeQGfTr4Dxkg
oO9GmxaVziXwOGuyYR4giygCHmNbPsSPK2uWRQ5VcTRjZwzYpV8Rv2NKy7ZHRsgk
7swx2IYnVijlnWri2S4rsMXxqR5QkfqdCmOTXlwWukWUE9i8JTo2/EX2kx2Z+/j3
FNJeiexMFBINug==
=iqmd
-----END PGP SIGNATURE-----
--=-=-=--
