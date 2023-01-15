Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF7C66B099
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 12:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbjAOLZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 06:25:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbjAOLZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 06:25:57 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF583A87
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 03:25:55 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1673781953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3v1EntWB9hscrgaIPvzEN6voYTcu4tzD4oH9Pvcik70=;
        b=QHRrcOjqaU6gOJh2GwD90044Xulnze2UDWAkOMsW3H/MO3a92UW9nReWRSw+2ey8EUNlgB
        IBhE++6d2RQboeH/kF4gYs/ssupV88BpNe3GpR736q+kWR3CeWoafpCHGs8hRS4HY4SZlc
        x4IbX+2THVRYi80fV5fgeiO/7NLJuQuTHPkfOC4dNPHZZYSRoaxvnNyKgYINmAtX+pj3VH
        Dx1RdL1wYo8ySiKcknr3COj3NtONoTTXAvalrsIIj8Sv+7nUkHIxiwxPokH1nm0/n4sQzw
        3EWSWON3esQA5AU0ibRmT2JIKYEts3YGBOys+V79/rTZzPVwOK80+YvMxrrq+g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1673781953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3v1EntWB9hscrgaIPvzEN6voYTcu4tzD4oH9Pvcik70=;
        b=8/oL2NIMXFE5EeJfeMRnIpVFTA2L9ufWBACyy2kbNZg34BL/x6FwMj7JVnhEgxRy21eRJT
        LvMU3nkKzZUi9mDg==
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Vijayakannan Ayyathurai <vijayakannan.ayyathurai@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>
Subject: Re: [PATCH net v1] net: stmmac: Fix queue statistics reading
In-Reply-To: <Y8LFyqcpi6RjcjMo@lunn.ch>
References: <20230114120437.383514-1-kurt@linutronix.de>
 <Y8LFyqcpi6RjcjMo@lunn.ch>
Date:   Sun, 15 Jan 2023 12:25:51 +0100
Message-ID: <87fsccvy2o.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Andrew,

On Sat Jan 14 2023, Andrew Lunn wrote:
> On Sat, Jan 14, 2023 at 01:04:37PM +0100, Kurt Kanzenbach wrote:
>> Correct queue statistics reading. All queue statistics are stored as unsigned
>> long values. The retrieval for ethtool fetches these values as u64. However, on
>> some systems the size of the counters are 32 bit.
>
>> @@ -551,16 +551,16 @@ static void stmmac_get_per_qstats(struct stmmac_priv *priv, u64 *data)
>>  		p = (char *)priv + offsetof(struct stmmac_priv,
>>  					    xstats.txq_stats[q].tx_pkt_n);
>>  		for (stat = 0; stat < STMMAC_TXQ_STATS; stat++) {
>> -			*data++ = (*(u64 *)p);
>> -			p += sizeof(u64 *);
>> +			*data++ = (*(unsigned long *)p);
>> +			p += sizeof(unsigned long);
>
> As you said in the comment, the register is 32 bits.

Maybe the commit message is a bit misleading. There are no registers
involved here. The queue statistics are accounted in software. See
stmmac_txq_stats and stmmac_rxq_stats.

> So maybe u32 would be better than unsigned long?

The problem is pkt_n and irq_n are stored as longs. The size of these
are either 4 or 8 byte depending on the architecture this code runs
on. I my opinion we cannot use u32 or u64 for that reason.

BTW, all the other stmmac statistic counters follow a different
pattern. For example:

for (i = 0; i < STMMAC_MMC_STATS_LEN; i++) {
	char *p;
	p = (char *)priv + stmmac_mmc[i].stat_offset;

	data[j++] = (stmmac_mmc[i].sizeof_stat ==
		     sizeof(u64)) ? (*(u64 *)p) :
		     (*(u32 *)p);
}

> And it would also avoid issues if this code is every used on a 64 bit
> machine.

The current code runs fine on 64 bit architectures such as Intel EHL,
TGL, ADL, ... I'm trying to fix it for the 32 bit case.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmPD4r8THGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgmc8D/4h+vMhAUUx7drZC4OK6MBVCFufO0og
sqc+WGKXshmvywbY83xQC6fsdm4pQDSJ0CjjX5x3Xfqr4S9V7jvkd3jG350nS5vt
1SHMvBQAcRbABV23e35cr+nTHRaN+zL/wTMWk+ZaA4zhwWztE46WwwsmPw//EI8S
jfWqKDfYpi4UIMlaZhm5AQtCBRGnfb/7+wzOUOELi1GIFbzq4HJ6jcq9diJamo5Q
N26HSk/fRHM3NtuCtHWe4nyjRguHEEOXGJqOakgdtUIcXAz/AQ4IgH+BekyUyKW3
TywTcRVUz3rxV21ttPTIGd3lKEN5MRrHTXBnds0RieVyJMwWMkppcZuckbYuZrXv
HKiASH76ap5AvKy6VKkjU5LTSoX/yH7l6sx47vPiUhtJ2/V83S5t24i53av3J5QX
F8K+FzvL+4kbZKcMJhTprmDO+5ojgaoXtzsC1nQjPZmv7W4EB50iMDhASUMrheiU
PN3OSApBIGzn8A5qJ/noy7GN5/4zDDsUBdhd4zi4zQfLYSpEC6lUo/Xhy8BtjY85
hDRcI3cpmVBEyc3c6gfK2REms++mDJ+TH2BsmMJaeQinFY1RzWNgyUD9uYIhkOqe
Ou/Oev4snyalP3EVwXWdQcjXkBUdM9ZLMtD+bagR2pZTov8g9YBClk/zoMjGb8RF
HnomIheLXGeuAg==
=eYvN
-----END PGP SIGNATURE-----
--=-=-=--
