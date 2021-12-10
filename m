Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A88446FE80
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 11:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbhLJKNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 05:13:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbhLJKNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 05:13:42 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E97C061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 02:10:07 -0800 (PST)
From:   Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639131005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H9McyQ9MuBise9kEaMK0iwGANbPMdoM0lgD2I/oaTA0=;
        b=dX7uX6vvv0AIy4FbDrtO4i+rH42bjZuDHgKsPc0PdhZYCvClw6EHqHxJLtjrIZCeeM1FVh
        3qidyeiWPLC3/+bOsS53d0MqeTQT8D5JAb9/4uwpqJ2alWDii7Opbnsjl7bINAoknp9tMb
        qnXwLpu+kb3WAWdXrySeMG1DbhtlDH50xWga9Nmq2e1zn6EcC/tZaYnxGK9W7WdcB3klqx
        X4gq4ysWWYIcGJ780jSJ5MAiVXI4WLNwnctBXE8Yu2isFOd/rHFJpQEpsCNR0s/+OuQesH
        riyTOtiSD9c1v+HJrKq9OmDo0PMBdpH+VqYeJ+0M3fifAUEJeDb0tiJ2kTAitQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639131005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H9McyQ9MuBise9kEaMK0iwGANbPMdoM0lgD2I/oaTA0=;
        b=mjPTFo3Zshvd6jHmVWuzrzrYY+GnhPATApuAxG4mkAJkq/QC9j5xhzJREmYgCqZ4Nlf/yQ
        gb3hswro03CQhiBA==
To:     Ong Boon Leong <boon.leong.ong@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        alexandre.torgue@foss.st.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH net-next 2/2] net: stmmac: add tc flower filter for
 EtherType matching
In-Reply-To: <20211209151631.138326-3-boon.leong.ong@intel.com>
References: <20211209151631.138326-1-boon.leong.ong@intel.com>
 <20211209151631.138326-3-boon.leong.ong@intel.com>
Date:   Fri, 10 Dec 2021 11:10:04 +0100
Message-ID: <87fsr0zs77.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu Dec 09 2021, Ong Boon Leong wrote:
> This patch adds basic support for EtherType RX frame steering for
> LLDP and PTP using the hardware offload capabilities.
>
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>

[snip]

> +	if (match.mask->n_proto) {
> +		__be16 etype =3D ntohs(match.key->n_proto);

n_proto is be16. The ntohs() call will produce an u16.

Delta patch below.

Thanks,
Kurt

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/eth=
ernet/stmicro/stmmac/stmmac.h
index 35ff7c835018..d64e42308eb6 100644
=2D-- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -182,7 +182,7 @@ enum stmmac_rfs_type {
=20
 struct stmmac_rfs_entry {
        unsigned long cookie;
=2D       __be16 etype;
+       u16 etype;
        int in_use;
        int type;
        int idx;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/=
ethernet/stmicro/stmmac/stmmac_tc.c
index cb7400943bb0..afa918185cf7 100644
=2D-- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -759,7 +759,7 @@ static int tc_add_ethtype_flow(struct stmmac_priv *priv,
        flow_rule_match_basic(rule, &match);
=20
        if (match.mask->n_proto) {
=2D               __be16 etype =3D ntohs(match.key->n_proto);
+               u16 etype =3D ntohs(match.key->n_proto);
=20
                if (match.mask->n_proto !=3D ETHER_TYPE_FULL_MASK) {
                        netdev_err(priv->dev, "Only full mask is supported =
for EthType filter");

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJSBAEBCgA8FiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmGzJ3weHGt1cnQua2Fu
emVuYmFjaEBsaW51dHJvbml4LmRlAAoJEHkqW4HLmPCm0HgQAKCym+iwmw9dZxIj
NTjjYl/OasE0mS+A7hCx12KB5kxw0zgSq1gzjXcuIfqHovQjV3ObFc6WPzNG+y7M
IEF0jrNJx78dMWzBKLHGmzhR88r8eG/o5BhLUVjMqMbzCVD/Xj5z/dhe8BzPLeS2
w8hn/EXnYOiWzm4gInKm3T26y0cazH+XwV34dYQVkduAJwFLNhlaFRf9SQ1A7eOh
GQJ6biGNRCND296ZtJ/qGkUVd0N5lqIdHe7TOYHOTwSlnUqKwAblRWM3Ck505VMT
RbGOPTxGybADkNivRebRkhz0wwf6DzVprHD6QnVurLJg7MM3NP9yIHMWE0wA1bZA
XdJyP448rKMahd6uTVmJP7WAAV/pHDGVg+BxZlewOCAvwN4cxbmgmTvpSt/Fvrpf
P8NgTqMY5pvn1AfsC8O+aqm2N68kxefEyw24Tpbpc1ZSMXr+e5vEkX3hZx4VAPzc
+HyHSBuLnsJmSEX5s7fuFQqBVeQTGJ62oDEP4lBk6m30hswDREXobklConGitrqH
IV6LHimyJTpONjb6WjVZqv5apkGq5JQQadrVE32HU2L1Q6IgAFYWyhhuAIRKPWla
550X0dYUo9+oaVIHjQgKdmxdwqcnHr1nk+0J2rUPM3JXC8+Jtglbp6KBiEjyvXPv
USbIhJuAdOokNaFzvY+F6vTwRY3G
=44Bn
-----END PGP SIGNATURE-----
--=-=-=--
