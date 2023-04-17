Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0276E4FAA
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 19:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjDQRxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 13:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjDQRxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 13:53:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 013DE40FC;
        Mon, 17 Apr 2023 10:53:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A52C61F61;
        Mon, 17 Apr 2023 17:53:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44617C433D2;
        Mon, 17 Apr 2023 17:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681754001;
        bh=6DYIOeMH2/MwXWM7L636bO7CJIjjghRBQlZZ4EkZRT8=;
        h=Date:From:To:Cc:Subject:From;
        b=tbqPGz+WhfLwlheZUGSa6aBPxK4hjwv/Cx/XnWUZLsrQaFyG3Qiv677Wnm/dMv3M7
         8uvg//MbyFx5U6dqFELGxjPWgV9bNiFkZ9s8Dvud933sSD6k5KCWH1rvIF4KpRFB1a
         7C9sdb2to6VIv2Kwk1JNQtN8lAxGOFoQdLx5iQz6TXdBJiu6Cwkx7NwPGayZJdzJBG
         LCAVfp2Jpyq2o9jnZ3XHFkD1PlU0o+1auDpEKwpkbvRTPRs4DtpWnbAK00mTXYcGCW
         f1F7urrjwzbJpV+WUb/exDpfecm0EPcFaP0j7RwdXq+rczztIPojwMBS/jWFb4bezB
         zXr+g2HuN58EA==
Date:   Mon, 17 Apr 2023 19:53:17 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     hawk@kernel.org, ilias.apalodimas@linaro.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        bpf@vger.kernel.org, lorenzo.bianconi@redhat.com, nbd@nbd.name
Subject: issue with inflight pages from page_pool
Message-ID: <ZD2HjZZSOjtsnQaf@lore-desk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="FdGMQvvSKL5XaD/h"
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--FdGMQvvSKL5XaD/h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

I am triggering an issue with a device running the page_pool allocator.
In particular, the device is running an iperf tcp server receiving traffic
=66rom a remote client. On the driver I loaded a simple xdp program returni=
ng
xdp_pass. When I remove the ebpf program and destroy the pool, page_pool
allocator starts complaining in page_pool_release_retry() that not all the =
pages
have been returned to the allocator. In fact, the pool is not really destro=
yed
in this case.
Debugging the code it seems the pages are stuck softnet_data defer_list and
they are never freed in skb_defer_free_flush() since I do not have any more=
 tcp
traffic. To prove it, I tried to set sysctl_skb_defer_max to 0 and the issue
does not occur.
I developed the poc patch below and the issue seems to be fixed:

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 193c18799865..160f45c4e3a5 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -19,6 +19,7 @@
 #include <linux/mm.h> /* for put_page() */
 #include <linux/poison.h>
 #include <linux/ethtool.h>
+#include <linux/netdevice.h>
=20
 #include <trace/events/page_pool.h>
=20
@@ -810,12 +811,23 @@ static void page_pool_release_retry(struct work_struc=
t *wq)
 {
 	struct delayed_work *dwq =3D to_delayed_work(wq);
 	struct page_pool *pool =3D container_of(dwq, typeof(*pool), release_dw);
-	int inflight;
+	int cpu, inflight;
=20
 	inflight =3D page_pool_release(pool);
 	if (!inflight)
 		return;
=20
+	/* Run NET_RX_SOFTIRQ in order to free pending skbs in softnet_data
+	 * defer_list that can stay in the list until we have enough queued
+	 * traffic.
+	 */
+	for_each_online_cpu(cpu) {
+		struct softnet_data *sd =3D &per_cpu(softnet_data, cpu);
+
+		if (!cmpxchg(&sd->defer_ipi_scheduled, 0, 1))
+			smp_call_function_single_async(cpu, &sd->defer_csd);
+	}
+
 	/* Periodic warning */
 	if (time_after_eq(jiffies, pool->defer_warn)) {
 		int sec =3D (s32)((u32)jiffies - (u32)pool->defer_start) / HZ;

Is it ok or do you think there is a better solution for issue?
@Felix: I think we faced a similar issue in mt76 unloading the module, righ=
t?

Regards,
Lorenzo

--FdGMQvvSKL5XaD/h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZD2HjQAKCRA6cBh0uS2t
rABxAPwNFxl1a2X/8AizFuuEFnBIXXQUjTqEPBt+VJ2S5nCdvgD+JWDBQGuoHczv
03cYs9N49vAYZxFC4ycY788TGY8TbwA=
=s5o0
-----END PGP SIGNATURE-----

--FdGMQvvSKL5XaD/h--
