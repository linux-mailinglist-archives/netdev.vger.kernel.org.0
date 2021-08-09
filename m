Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E82273E43C7
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 12:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234189AbhHIKVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 06:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232707AbhHIKVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 06:21:12 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E71C0613D3;
        Mon,  9 Aug 2021 03:20:51 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GjsYD1g0Yz9sWl;
        Mon,  9 Aug 2021 20:20:47 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1628504448;
        bh=7cEFw8ynauDK4goZ/MM69I2R5gnSYKAhB0jRrkT5IVk=;
        h=Date:From:To:Cc:Subject:From;
        b=QjRjzL8w73N/oz3+neFluG+OEeoGCR16LDwyW6pam3XPzyWKXV+lNzCvH+Phrk62p
         jnc/Ki3zea+JFdB7uqKa2pVrqqF0YA6pFYrlmRPpAn+w9pOL7kE1mpwa4ukPXtdeFJ
         wJxAan0jHxtyaVceAME7OGKwtts3hVaE91O0AT8Frkb5d1dt4J1jN/G3Cz4OYDXccQ
         eBKttATVOaiAsTXbHeZi12xceQEffESuMaMVmbiqARSxmS+DWQQumlvVoKsZBGj1GM
         MI2QAkgVO6/cllFqztWD4pWXOXTRIIN4An2rRSWq2DFEq8dUnSqjRyd5Zc4QZ+tUWq
         faW5cmunQv2Eg==
Date:   Mon, 9 Aug 2021 20:20:46 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20210809202046.596dad87@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/C=Uh9Vo5jtX2PcJN0p3p_nA";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/C=Uh9Vo5jtX2PcJN0p3p_nA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/net/ethernet/cirrus/cs89x0.c: In function 'net_open':
drivers/net/ethernet/cirrus/cs89x0.c:897:20: error: implicit declaration of=
 function 'isa_virt_to_bus' [-Werror=3Dimplicit-function-declaration]
  897 |     (unsigned long)isa_virt_to_bus(lp->dma_buff));
      |                    ^~~~~~~~~~~~~~~
include/linux/dynamic_debug.h:134:15: note: in definition of macro '__dynam=
ic_func_call'
  134 |   func(&id, ##__VA_ARGS__);  \
      |               ^~~~~~~~~~~
include/linux/dynamic_debug.h:162:2: note: in expansion of macro '_dynamic_=
func_call'
  162 |  _dynamic_func_call(fmt, __dynamic_pr_debug,  \
      |  ^~~~~~~~~~~~~~~~~~
include/linux/printk.h:570:2: note: in expansion of macro 'dynamic_pr_debug'
  570 |  dynamic_pr_debug(fmt, ##__VA_ARGS__)
      |  ^~~~~~~~~~~~~~~~
drivers/net/ethernet/cirrus/cs89x0.c:86:3: note: in expansion of macro 'pr_=
debug'
   86 |   pr_##level(fmt, ##__VA_ARGS__);   \
      |   ^~~
drivers/net/ethernet/cirrus/cs89x0.c:894:3: note: in expansion of macro 'cs=
89_dbg'
  894 |   cs89_dbg(1, debug, "%s: dma %lx %lx\n",
      |   ^~~~~~~~

Caused by commit

  47fd22f2b847 ("cs89x0: rework driver configuration")

I have removed the COMPILE_TEST from NET_VENDOR_CIRRUS for now.

--=20
Cheers,
Stephen Rothwell

--Sig_/C=Uh9Vo5jtX2PcJN0p3p_nA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmERAX4ACgkQAVBC80lX
0GzNLAf+Jfaz8JLllwnRCtEDfnYzHLi2UdTZNANcsz921bap4ZN7J15QL34FgXK0
iF42HeK6u8sT2kD/kxgxSlJtT/iTL9q6XqHpEfNAJUdBqLjc+xAZ7U62s7Z10rts
vhfO7+eigVDMtll0+VY3BHoPv0/Ljw0gQYUFxiWZAmfqvWG3BjSB3oOdbqvnEOlG
butqYjaxGv8hLKJYPhwn7QZU6OuRKltFyk57e0xtZ0vPCqdyQmeb+KbGWaSqV2Kj
2UTh9kd9hLNdrUKLHhW3y0LtpSu8aJj8jHUXjidAjcq4uBuFPrGSNQT1onaHDJX6
IJaJXHodmJtr7KPZhiG797OhbqD7sw==
=JsQt
-----END PGP SIGNATURE-----

--Sig_/C=Uh9Vo5jtX2PcJN0p3p_nA--
