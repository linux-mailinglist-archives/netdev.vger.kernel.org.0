Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12373646FA3
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 13:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiLHM21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 07:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiLHM20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 07:28:26 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724CE1F9FC
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 04:28:25 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1670502502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aYSJYBoq80HnFp073vg7JvCH48Wo0Spy8hIPZiDaa9I=;
        b=2MBXIcVzpFKkHldC086hoFBDvSyJor3gMw/g+OKMpQAMuNM8e3izuWimaG/mOqQjvJ1gLr
        SyMQcsGwruT3qhV+0Q8A+XEXd8L3QFJYYH24rrJZbmV8kGSPX6cLB80pku5vh7mQ4Y+lCI
        jFUzJ2dSN+0Qi+k6gJTjsuck3gZmKfXpicdM3o7F4eQNSevK6OYrGz5PHm9jMIuHJRubae
        ZU8BKS91+gKgIGm1HZ/UCoo6qOJm9V1E0+ImcqroyrzVO0SKJnJ4f5poCHD6+HPXw/cIsB
        BlFNDyApgjdmBE9/kqrXcZPLeJmWZwPpIuAkfAsaJxpM1am+XbKs3XIGueb3kg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1670502502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aYSJYBoq80HnFp073vg7JvCH48Wo0Spy8hIPZiDaa9I=;
        b=Tl+7+ANnDDd3mJP0obhaFM2vag33o0kV89CC8TQekaWJPNu5LskgC5YLH6b0KkQb3M5uYY
        w1mjYA6cBbX+ICDg==
To:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Cc:     Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sasha.neftin@intel.com, Tan Tee Min <tee.min.tan@linux.intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: Re: [PATCH net-next 2/8] igc: remove I226 Qbv BaseTime restriction
In-Reply-To: <20221205212414.3197525-3-anthony.l.nguyen@intel.com>
References: <20221205212414.3197525-1-anthony.l.nguyen@intel.com>
 <20221205212414.3197525-3-anthony.l.nguyen@intel.com>
Date:   Thu, 08 Dec 2022 13:28:21 +0100
Message-ID: <87pmcu13mi.fsf@kurt>
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

On Mon Dec 05 2022, Tony Nguyen wrote:
> From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
>
> Remove the Qbv BaseTime restriction for I226 so that the BaseTime can be
> scheduled to the future time. A new register bit of Tx Qav Control
> (Bit-7: FutScdDis) was introduced to allow I226 scheduling future time as
> Qbv BaseTime and not having the Tx hang timeout issue.
>
> Besides, according to datasheet section 7.5.2.9.3.3, FutScdDis bit has to
> be configured first before the cycle time and base time.
>
> Indeed the FutScdDis bit is only active on re-configuration, thus we have
> to set the BASET_L to zero and then only set it to the desired value.
>
> Please also note that the Qbv configuration flow is moved around based on
> the Qbv programming guideline that is documented in the latest datasheet.
>
> Co-developed-by: Tan Tee Min <tee.min.tan@linux.intel.com>
> Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
> Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
> Tested-by: Naama Meir <naamax.meir@linux.intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

[snip]

> @@ -5852,8 +5853,10 @@ static bool validate_schedule(struct igc_adapter *adapter,
>  	 * in the future, it will hold all the packets until that
>  	 * time, causing a lot of TX Hangs, so to avoid that, we
>  	 * reject schedules that would start in the future.
> +	 * Note: Limitation above is no longer in i226.
>  	 */
> -	if (!is_base_time_past(qopt->base_time, &now))
> +	if (!is_base_time_past(qopt->base_time, &now) &&
> +	    igc_is_device_id_i225(hw))
>  		return false;

Nothing against this patch per se, but you should lift the base time
restriction for i225 as well. Even if it's hardware limitation, the
driver should deal with that e.g., using a timer, workqueue, ... The
TAPRIO interface allows the user to set an arbitrary base time, which
can and most likely will be in the future. IMHO the driver should handle
that. For instance, the hellcreek TSN switch has a similar limitation
(base time can only be applied up to 8 seconds in the future) and I've
worked around it in the driver.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmOR2GUTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgtQ3EACL7Ho0RpbyPjSQ0GqEZMTIxf34KOXf
5a5a1tIaY9e7klLmEzTh4diYxMMon5UVQW98tZo5gHzw145WvJuB8nFQlWxLb6Jp
k1tWW16njQe7W8T5yeS7JIXEEWaTMWpE+DmFzII0iHww8siSA8B9OSfIUAoHEHQb
G+39agjnrt9YdPdx51+zBgvV+DfHT4LswJMxtngJ2SiF8FdiLL3HKfCzNLd5BsS4
iw6mZAtqQXyJCj/kRS9t/Roj84lueNvdmPX97B53wNft1mz1vH3iCXKclWfCgiEh
p+p2ju+V6+CvwFctJ4os3HEfTGUqdnybbY9juI+eZZWqrR4GzWbNdr2NZOfwRmxI
nrjWr0q241ZxsQ3tXua31wgRQCJST7KCyeTDypyw6y/bmenF0iNZ4hgBNjFSIqfX
zpfiXAueKqCOGb/ETVCTwG/mGl012T5EUMOEOXYUjHFa4Cq7SRncs8lIpkzKfoz0
M4HoiRLUwrfQiS5maW+ZYZnL7Mx2syKu/uEqkO3uPJZyWLPrqVSUodacr4fpxA1/
C3sTL2YixRNA+ttDpPrD6v8ydHxS4YIjPFKwL8sezosArIwmeqYhlvkMfX1ids3z
N4V+CXYp8JagBG+6rgd2NMxzRlj2zsgn+R53jfR72Rg2h3OoB4uc52rhCHkA0K9L
YCbO8AWlMzHNMQ==
=YgZc
-----END PGP SIGNATURE-----
--=-=-=--
