Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA2353F6D9
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 09:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbiFGHHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 03:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiFGHG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 03:06:58 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A127E1FD
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 00:06:56 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1654585614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hcprdh1Yb1B+tSD6sJzXR6E2HBqZvDFe1oTNb0UH3E8=;
        b=n0WXtUVb6QVbfnpRwRK6vfQs2kxSb7KtbYEkzl+WVPCewQxhpXyW+81T2aUIDN2YsHWGpg
        HrZwyOwxoDEs5lJiccd3GXE3ZvA1PPA54bfcb5g1PE6kwVTNQUognON7dPitj0PpoPOtvk
        URhkZHt+tZAkX2EjyjrpgHBODoVenOh7ApmXl8R600tGovwm5hbYgo6Qu3C7WicTeI9+sg
        YlHpyPSUOhEJFrkK6qjeTixV/OajXJMpdCONqGsuCP4s8S0xBWGGPhEv0UtCa+bo458jve
        TjIj7H0Y08d44wM05lZviGGBHRLk5DS7JNOheT00xTEndf6E/bzIeyBvty26qA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1654585614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hcprdh1Yb1B+tSD6sJzXR6E2HBqZvDFe1oTNb0UH3E8=;
        b=bUpMPhqDlqDqZlHi1d0nR3jD3mM3rYZYSJHqYl0ICVHDgJI57aCCLwRVvWZEePmcEylXTw
        nxpBMsQ5tiysbWBQ==
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] igc: Lift TAPRIO schedule restriction
In-Reply-To: <8735ghny8m.fsf@intel.com>
References: <20220606092747.16730-1-kurt@linutronix.de>
 <8735ghny8m.fsf@intel.com>
Date:   Tue, 07 Jun 2022 09:06:53 +0200
Message-ID: <87k09tar5e.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Vinicius,

On Mon Jun 06 2022, Vinicius Costa Gomes wrote:
> Hi Kurt,
>
> Kurt Kanzenbach <kurt@linutronix.de> writes:
>
>> Add support for Qbv schedules where one queue stays open
>> in consecutive entries. Currently that's not supported.
>>
>> Example schedule:
>>
>> |tc qdisc replace dev ${INTERFACE} handle 100 parent root taprio num_tc =
3 \
>> |   map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
>> |   queues 1@0 1@1 2@2 \
>> |   base-time ${BASETIME} \
>> |   sched-entry S 0x01 300000 \ # Stream High/Low
>> |   sched-entry S 0x06 500000 \ # Management and Best Effort
>> |   sched-entry S 0x04 200000 \ # Best Effort
>> |   flags 0x02
>>
>> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
>> ---
>>  drivers/net/ethernet/intel/igc/igc_main.c | 23 +++++++++++++++++------
>>  1 file changed, 17 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/eth=
ernet/intel/igc/igc_main.c
>> index ae17af44fe02..4758bdbe5df3 100644
>> --- a/drivers/net/ethernet/intel/igc/igc_main.c
>> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
>> @@ -5813,9 +5813,10 @@ static bool validate_schedule(struct igc_adapter =
*adapter,
>>  		return false;
>>=20=20
>>  	for (n =3D 0; n < qopt->num_entries; n++) {
>> -		const struct tc_taprio_sched_entry *e;
>> +		const struct tc_taprio_sched_entry *e, *prev;
>>  		int i;
>>=20=20
>> +		prev =3D n ? &qopt->entries[n - 1] : NULL;
>>  		e =3D &qopt->entries[n];
>>=20=20
>>  		/* i225 only supports "global" frame preemption
>> @@ -5828,7 +5829,12 @@ static bool validate_schedule(struct igc_adapter =
*adapter,
>>  			if (e->gate_mask & BIT(i))
>>  				queue_uses[i]++;
>>=20=20
>> -			if (queue_uses[i] > 1)
>> +			/* There are limitations: A single queue cannot be
>> +			 * opened and closed multiple times per cycle unless the
>> +			 * gate stays open. Check for it.
>> +			 */
>> +			if (queue_uses[i] > 1 &&
>> +			    !(prev->gate_mask & BIT(i)))
>
> Perhaps I am missing something, I didn't try to run, but not checking if
> 'prev' can be NULL, could lead to crashes for some schedules, no?

My thinking was that `prev` can never be NULL, as `queue_uses[i] > 1` is
checked first. This condition can only be true if there are at least two
entries.

>
> What I have in mind is a schedule that queue 0 is mentioned multiple
> times, for example:
>
>  |   sched-entry S 0x01 300000 \ # Stream High/Low
>  |   sched-entry S 0x03 500000 \ # Management and Best Effort
>  |   sched-entry S 0x05 200000 \ # Best Effort
>

So, this schedule works with the proposed patch. Queue 0 is opened in
all three entries. My debug code shows:

|tc-6145    [010] .......   616.190589: igc_setup_tc: Qbv configuration:
|tc-6145    [010] .......   616.190592: igc_setup_tc: Queue 0 -- start_time=
=3D0 [ns]
|tc-6145    [010] .......   616.190592: igc_setup_tc: Queue 0 -- end_time=
=3D1000000 [ns]
|tc-6145    [010] .......   616.190593: igc_setup_tc: Queue 1 -- start_time=
=3D300000 [ns]
|tc-6145    [010] .......   616.190593: igc_setup_tc: Queue 1 -- end_time=
=3D800000 [ns]
|tc-6145    [010] .......   616.190593: igc_setup_tc: Queue 2 -- start_time=
=3D800000 [ns]
|tc-6145    [010] .......   616.190594: igc_setup_tc: Queue 2 -- end_time=
=3D1000000 [ns]
|tc-6145    [010] .......   616.190594: igc_setup_tc: Queue 3 -- start_time=
=3D800000 [ns]
|tc-6145    [010] .......   616.190594: igc_setup_tc: Queue 3 -- end_time=
=3D1000000 [ns]

Anyway, I'd appreciate some testing on your side too :).

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmKe+Q0THGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgoJtEACci4/I7W93tKhTZAvB4kpPoC/W41+x
3WVZ005iQG1tj10ItvR1EqQl+0jRT7esrukvmNMgrXNvqVCDC52k6rHu0lr0Wuvv
vYouZHvOlYXbBThN0AT0ALy0OtJrrYqlmt/LBpdwMfuH4w1tvx2XMQNkL1/TzfxM
hoVJdrI2/SZ7CZrBiXnBrY5LRwZHyyuDRruOGDf21Z+tt1q5ele4Q6/GvhoBQVmK
L37WuM9DouOl+IqMskWcSCf1ul1SDL93CJRHNAUn3jRGvTrvZHVkgOuzp580sQK8
413dyjIgtcPnzLCb/Jm/gsZkdCJcm1RNbS32t6W6yOcfpvx+EeQ1pJp/Vt/0CIPQ
TdGw3o39zFJaHcFcw4pa2gm+3VqUcoWeY/dIt62/dnGSTDxhUhMR7A4+hD02M6nt
pnFkWQQoBjh7BAWiWiDSn50AAkZi1ww0Qyfn/sleyoli4r1+g+UTUO+mmW2hj04y
66kl80YDPooaWx8iZMdgvzNyyExh5IF2RmjLlPBTjskuIsheGm85jTzDYE0tSsDt
KVhQF75nTjAmHy7yzotd1k7Yp+1KNYSX16nmoZDGivyaEoUFu5lOeUipU4JOnvA8
ij5u+70enDMnS6372ZOvbhtG0hCuXaw6rM23WnO1gkt/ygPVz921BMTWqjPtoefA
c6aIfSQUH6BfhQ==
=aEQE
-----END PGP SIGNATURE-----
--=-=-=--
