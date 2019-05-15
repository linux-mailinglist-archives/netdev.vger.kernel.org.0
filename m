Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACE0F1FC5E
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 23:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfEOVmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 17:42:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:57960 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726780AbfEOVmi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 May 2019 17:42:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E1A46AD47;
        Wed, 15 May 2019 21:42:36 +0000 (UTC)
From:   NeilBrown <neilb@suse.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>, davem@davemloft.net
Date:   Thu, 16 May 2019 07:42:29 +1000
Cc:     herbert@gondor.apana.org.au, tgraf@suug.ch, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: Re: [PATCH net] rhashtable: fix sparse RCU warnings on bit lock in bucket pointer
In-Reply-To: <20190515205501.17810-1-jakub.kicinski@netronome.com>
References: <20190515205501.17810-1-jakub.kicinski@netronome.com>
Message-ID: <87sgtfwg1m.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, May 15 2019, Jakub Kicinski wrote:

> Since the bit_spin_lock() operations don't actually dereference
> the pointer, it's fine to forcefully drop the RCU annotation.
> This fixes 7 sparse warnings per include site.
>
> Fixes: 8f0db018006a ("rhashtable: use bit_spin_locks to protect hash buck=
et.")
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>

Hi, sorry for not responding to your initial post, but I'm otherwise
engaged this week and cannot give it any real time.  I don't object to
this patch, but I'll try to have a proper look next week, if only to
find out how I didn't get the warnings, as I was testing with sparse.

Thanks,
NeilBrown


> ---
>  include/linux/rhashtable.h | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
> index f7714d3b46bd..bea1e0440ab4 100644
> --- a/include/linux/rhashtable.h
> +++ b/include/linux/rhashtable.h
> @@ -325,27 +325,27 @@ static inline struct rhash_lock_head __rcu **rht_bu=
cket_insert(
>   */
>=20=20
>  static inline void rht_lock(struct bucket_table *tbl,
> -			    struct rhash_lock_head **bkt)
> +			    struct rhash_lock_head __rcu **bkt)
>  {
>  	local_bh_disable();
> -	bit_spin_lock(0, (unsigned long *)bkt);
> +	bit_spin_lock(0, (unsigned long __force *)bkt);
>  	lock_map_acquire(&tbl->dep_map);
>  }
>=20=20
>  static inline void rht_lock_nested(struct bucket_table *tbl,
> -				   struct rhash_lock_head **bucket,
> +				   struct rhash_lock_head __rcu **bkt,
>  				   unsigned int subclass)
>  {
>  	local_bh_disable();
> -	bit_spin_lock(0, (unsigned long *)bucket);
> +	bit_spin_lock(0, (unsigned long __force *)bkt);
>  	lock_acquire_exclusive(&tbl->dep_map, subclass, 0, NULL, _THIS_IP_);
>  }
>=20=20
>  static inline void rht_unlock(struct bucket_table *tbl,
> -			      struct rhash_lock_head **bkt)
> +			      struct rhash_lock_head __rcu **bkt)
>  {
>  	lock_map_release(&tbl->dep_map);
> -	bit_spin_unlock(0, (unsigned long *)bkt);
> +	bit_spin_unlock(0, (unsigned long __force *)bkt);
>  	local_bh_enable();
>  }
>=20=20
> --=20
> 2.21.0

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlzch8UACgkQOeye3VZi
gbkcwRAAv99R791bdigGPksDIxC3uvl7DOoxRzXaDz6YZE0cwuSmjJutIB7nwRab
tsqY/E76pvrV+dQT1UVLz2vL0Rc8DBy9ZDkLLNB+R/aKSn67pV0PgwTa2d1nUzXF
giQwJH19RT9rIjhFXQXusuNlekXGa4Y8ex0xUKRw8tPcNwSKjiiLDtj6LMMRtMJE
FL5qze8gCoin8bs1Y/ITA/7GVpWx0KJ8MeNq4jsIrXuXNd/RRi5rJpSIRufvchR/
RZ8adexrxQqxn7vnsScGRhLUN0Bnz8ovStnSKVp5Xqfmwy8FC+dE3nytHdSyTJ4f
KCy3Gg0cykDNbhouHe8dksAwSct+CEooJdERCw0wYxFc1PanU/qtv51Fn8Um0qvM
uIDqmkrMiw3HEXjPho1Ed4OgctqNCWuzVvnPgVBSeH+gNRDipwPZKOyVDlS2TM5H
89GRrfzhqCsn6Rrb5qlgFnZ3neqpSykHLBh+Eg2xsSawRx/dmeaHWgv25aiJ3kQt
enHfDeSz0I4eTzR2iM9cQIiXic06GzcA9egey408m53J6CusckN7RfhgPR+j1PtV
bI6g9GRofxaMA74qFpZykf5MqSJPgaPMrUv1eSBz1ME0OGBfcEiYID2ZftegI1gP
jBl+wVPfuzKkF2YzhNAU+9+jqJQVGWj11XkpKdPGSMT1vZqZRJw=
=n61K
-----END PGP SIGNATURE-----
--=-=-=--
