Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD0B95427FA
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 09:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232017AbiFHHWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 03:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353253AbiFHGQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 02:16:35 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A13A3391
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 23:00:40 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1654668038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xdbpm7rEw5pv+R6HDC4sqpJiOYOsoxsHStsgWZduYnM=;
        b=UDfWj9LL2TRANBMSQkcdwwRcRRfpu3E/zzefmRdAzb5KkIGEhAHVb8EX3FSTKiOP6zrYDd
        VT/XTBQaPUpqFcwTIZvO+XnN5x7gHbRNWQKVSzt9SUrfFuD01moQvC7vZlVijrTwcIVmSw
        lRJBAdHo/8agJSgpn3I9Dlca9jnNiEhCSkQtmSs7SfQIj2aamWpR233hxm2uQws8ERwtWj
        AKOFHoI0E3E4W84LBy9bVmlhgMpN6jmdF/a7A+SVPcxCsmPaOpeOqDGWeBrSinuVN1MTfD
        uDda1MywXnxdKyvZEMbiPBKvN/KI/C4hzLyf1LJp78h77ajKoV0lMIQ6+YPFcw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1654668038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xdbpm7rEw5pv+R6HDC4sqpJiOYOsoxsHStsgWZduYnM=;
        b=AtfFfi+JsCobOQ+a/eHwTJEBu0zbLQDpsS3keyz0BnhEsnYuOywUm5qiDVbVaU/doGPyWB
        w1hIItaPU4ZkN5Bg==
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] igc: Lift TAPRIO schedule restriction
In-Reply-To: <87wndsmm43.fsf@intel.com>
References: <20220606092747.16730-1-kurt@linutronix.de>
 <8735ghny8m.fsf@intel.com> <87k09tar5e.fsf@kurt>
 <87wndsmm43.fsf@intel.com>
Date:   Wed, 08 Jun 2022 08:00:37 +0200
Message-ID: <8735gfzoca.fsf@kurt>
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

>>> What I have in mind is a schedule that queue 0 is mentioned multiple
>>> times, for example:
>>>
>>>  |   sched-entry S 0x01 300000 \ # Stream High/Low
>>>  |   sched-entry S 0x03 500000 \ # Management and Best Effort
>>>  |   sched-entry S 0x05 200000 \ # Best Effort
>>>
>>
>> So, this schedule works with the proposed patch. Queue 0 is opened in
>> all three entries. My debug code shows:
>>
>> |tc-6145    [010] .......   616.190589: igc_setup_tc: Qbv configuration:
>> |tc-6145    [010] .......   616.190592: igc_setup_tc: Queue 0 -- start_time=0 [ns]
>> |tc-6145    [010] .......   616.190592: igc_setup_tc: Queue 0 -- end_time=1000000 [ns]
>> |tc-6145    [010] .......   616.190593: igc_setup_tc: Queue 1 -- start_time=300000 [ns]
>> |tc-6145    [010] .......   616.190593: igc_setup_tc: Queue 1 -- end_time=800000 [ns]
>> |tc-6145    [010] .......   616.190593: igc_setup_tc: Queue 2 -- start_time=800000 [ns]
>> |tc-6145    [010] .......   616.190594: igc_setup_tc: Queue 2 -- end_time=1000000 [ns]
>> |tc-6145    [010] .......   616.190594: igc_setup_tc: Queue 3 -- start_time=800000 [ns]
>> |tc-6145    [010] .......   616.190594: igc_setup_tc: Queue 3 -- end_time=1000000 [ns]
>>
>> Anyway, I'd appreciate some testing on your side too :).
>
> Sure, I can give it a spin, but it'll have to be later in the week, kind
> of swamped right now.

No problem. Actually i'm out of office for the next two weeks. I'll
update the patch afterwards if required.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmKgOwUTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgnqOEACKdxFr2sRg1n7xQR5Gk8Tch/q16Tqg
qQrUZXlNcv5dMgBmyUXWLXXT/K3u4QOE9djy1KsS74GYo8fdfcXpOUHaeNxKn1ZP
RajheEG8Jkjo5Es2pLITqyMkTZ+Toc0EFC6uuuAZiTRqKb/5LXYQSHlWiLaav/UP
MoG+5/7NIAg/a+xAP9jtEUw6aALAH/18mHeHITsIqG8Pu6z05gvGMlR/VqYOU1tr
DAwv0F+2YCLx20HimMvLAUe0ar42fbaUkcL3bYoplihaoJev+A22FmNNRGsk6qtP
3a3vw9VhbtiGTmKgOdivzklBKk5k1lAPPLngTM568qD6nhYp+oiupwa3vj0wD4+5
XajAmlODe9hQAbXVuTOFu78Enkp9D7rHl33+BChTsx1BYTORGe9w8E9eTJ0PtNRJ
2smDUOAb2it7h283a/oaIr9p2tQF8BD4mNyFOJmkSMiTVX/PwC6VXIRyunYO6i1+
4pOfChu8ibDN4zoXnB0o8ANHsQQ8j4NoP1PJ56953Iahp4i95OB5ZmEnRz9b8aOn
ppYI8RvyQr4f9HEHYvGUeNPSgy7lMYlYzSVGTUT8P69QAQwNDqeMxP4bzyXMPAcx
2h0SgiAdnRcaziJ3Q6A6RC6J99Lg3g3+LKHxVjVumDNHI9RaODqoGQztTSuavA7n
DSoug1zWqshy5g==
=j42X
-----END PGP SIGNATURE-----
--=-=-=--
