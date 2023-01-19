Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 539D7672D90
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 01:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjASAle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 19:41:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjASAld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 19:41:33 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25A94C23;
        Wed, 18 Jan 2023 16:41:31 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Ny3j26br3z4xyB;
        Thu, 19 Jan 2023 11:41:26 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1674088887;
        bh=ue7xvIZGo+iI9hupprXGDGTEJGMk5Uq7aKC+TyTDNHk=;
        h=Date:From:To:Cc:Subject:From;
        b=nJ8FiNFiF8Lml5rqdCSaBhspeIsaI2RL4iaSmEUBsq6ZYtzP7L9kmoRlPUFFSMFyO
         mCFk74myn2RwAHNe7DAltuoVOlhZy+RTsXuvHNQ8PbeEezhzA07HB1omhu+9CcUxCl
         gysxDgSEuApK76BT8jExhVo/YWHHw05m0FWDEt4U71r3RsaIm0NDZVhB4h62OGzOfp
         b2I385KfPqzyzPqvag2uqmlGMIc+BSTRtSJEpXQ7fYgIDp5bou6mIfdFaoBt++PhAz
         JavmuUinPfnWPj5hYUY0kAEQbnKGZSC23PUgPjWy9brYRQFqMeQHiUlSIQZg4niFeu
         XvmJokFiVU51g==
Date:   Thu, 19 Jan 2023 11:41:25 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Alex Elder <elder@linaro.org>,
        Caleb Connolly <caleb.connolly@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20230119114125.5182c7ab@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/.BcyQ//Iass4WY=tHW+8ZVp";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/.BcyQ//Iass4WY=tHW+8ZVp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got conflicts in:

  drivers/net/ipa/ipa_interrupt.c
  drivers/net/ipa/ipa_interrupt.h

between commit:

  9ec9b2a30853 ("net: ipa: disable ipa interrupt during suspend")

from the net tree and commits:

  8e461e1f092b ("net: ipa: introduce ipa_interrupt_enable()")
  d50ed3558719 ("net: ipa: enable IPA interrupt handlers separate from regi=
stration")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc drivers/net/ipa/ipa_interrupt.c
index c1b3977e1ae4,fd982cec8068..000000000000
--- a/drivers/net/ipa/ipa_interrupt.c
+++ b/drivers/net/ipa/ipa_interrupt.c
@@@ -127,16 -129,29 +129,39 @@@ out_power_put
  	return IRQ_HANDLED;
  }
 =20
 +void ipa_interrupt_irq_disable(struct ipa *ipa)
 +{
 +	disable_irq(ipa->interrupt->irq);
 +}
 +
 +void ipa_interrupt_irq_enable(struct ipa *ipa)
 +{
 +	enable_irq(ipa->interrupt->irq);
 +}
 +
+ static void ipa_interrupt_enabled_update(struct ipa *ipa)
+ {
+ 	const struct ipa_reg *reg =3D ipa_reg(ipa, IPA_IRQ_EN);
+=20
+ 	iowrite32(ipa->interrupt->enabled, ipa->reg_virt + ipa_reg_offset(reg));
+ }
+=20
+ /* Enable an IPA interrupt type */
+ void ipa_interrupt_enable(struct ipa *ipa, enum ipa_irq_id ipa_irq)
+ {
+ 	/* Update the IPA interrupt mask to enable it */
+ 	ipa->interrupt->enabled |=3D BIT(ipa_irq);
+ 	ipa_interrupt_enabled_update(ipa);
+ }
+=20
+ /* Disable an IPA interrupt type */
+ void ipa_interrupt_disable(struct ipa *ipa, enum ipa_irq_id ipa_irq)
+ {
+ 	/* Update the IPA interrupt mask to disable it */
+ 	ipa->interrupt->enabled &=3D ~BIT(ipa_irq);
+ 	ipa_interrupt_enabled_update(ipa);
+ }
+=20
  /* Common function used to enable/disable TX_SUSPEND for an endpoint */
  static void ipa_interrupt_suspend_control(struct ipa_interrupt *interrupt,
  					  u32 endpoint_id, bool enable)
diff --cc drivers/net/ipa/ipa_interrupt.h
index 8a1bd5b89393,764a65e6b503..000000000000
--- a/drivers/net/ipa/ipa_interrupt.h
+++ b/drivers/net/ipa/ipa_interrupt.h
@@@ -85,22 -53,20 +53,36 @@@ void ipa_interrupt_suspend_clear_all(st
   */
  void ipa_interrupt_simulate_suspend(struct ipa_interrupt *interrupt);
 =20
 +/**
 + * ipa_interrupt_irq_enable() - Enable IPA interrupts
 + * @ipa:	IPA pointer
 + *
 + * This enables the IPA interrupt line
 + */
 +void ipa_interrupt_irq_enable(struct ipa *ipa);
 +
 +/**
 + * ipa_interrupt_irq_disable() - Disable IPA interrupts
 + * @ipa:	IPA pointer
 + *
 + * This disables the IPA interrupt line
 + */
 +void ipa_interrupt_irq_disable(struct ipa *ipa);
 +
+ /**
+  * ipa_interrupt_enable() - Enable an IPA interrupt type
+  * @ipa:	IPA pointer
+  * @ipa_irq:	IPA interrupt ID
+  */
+ void ipa_interrupt_enable(struct ipa *ipa, enum ipa_irq_id ipa_irq);
+=20
+ /**
+  * ipa_interrupt_disable() - Disable an IPA interrupt type
+  * @ipa:	IPA pointer
+  * @ipa_irq:	IPA interrupt ID
+  */
+ void ipa_interrupt_disable(struct ipa *ipa, enum ipa_irq_id ipa_irq);
+=20
  /**
   * ipa_interrupt_config() - Configure the IPA interrupt framework
   * @ipa:	IPA pointer

--Sig_/.BcyQ//Iass4WY=tHW+8ZVp
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmPIkbUACgkQAVBC80lX
0GzSXggAkSG81AWiNwJxh1GbXkQAu1I3st0cnn820naR9WlR/CfjCukmYYNiGArK
BBL+GnKsHzzEnC9VYOKLGdc5qQOOZUG2kZ29HamydsdllzzHx5MitycMEude2Gpv
AMfb/66M5sQ0gZjtoRmYcbAmCuubsJROenp8n8qUV6WOb9hwq5t1kt73RExx21l6
K4hji8wOBwzYUxHLHvfVWd2GMIQVPYFWg2WVuwdav7epXGxs2VlmzSRD7/nQwTj1
Dc6niBxseVwbeh3e6lWv1vqqpuMnFgfJZ3tZRRRpNjIHk91egWfebBOHRhHfjMod
h0akpjziAQvta5cj3E1GQ3yejp/PkA==
=KZx+
-----END PGP SIGNATURE-----

--Sig_/.BcyQ//Iass4WY=tHW+8ZVp--
