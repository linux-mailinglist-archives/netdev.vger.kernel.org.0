Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9937D603B23
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 10:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiJSIIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 04:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiJSIIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 04:08:09 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E917B2AB
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 01:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=dtu9vNtYtY7XCBPibfq1RqwPMZ066LD+55n/6Y03G9Y=;
        t=1666166888; x=1667376488; b=SyFo4wOzrAs9qAIxG1eVCagSoP/yCgwk96DW9wooNARyCe4
        6nVZaFycGRIwMiVDKpbYxaSPSOwWVDmuDAtA0dblhI7njz+hGI71i0PmjhgtdR1VUOGREZGREBPzQ
        QyekdtE0Gs//HWhdw1XlQlexRQgmAkn8GYCeK0871fyJwzWp8IMWyDDs3Tr7Z5GFHxd7xhyYx0hW5
        gmrcOt+zPGdF9cwc7Au1GIDXKD6W52/fFzCgDtlnh7pZwKj5NTWz8PDcBhyZ3arptFkG/LY6ZafIe
        3wBWbwKc2d9hqlJvMZbCCroAMQJ/ghZIYO9JvFOf9WKyDexxpU5ScO+RX2ecl8gQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ol47O-00B1S9-1T;
        Wed, 19 Oct 2022 10:08:02 +0200
Message-ID: <f608f1dc2d522a32a6cedbd44a6213c4d231464b.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 06/13] genetlink: add policies for both doit
 and dumpit in ctrl_dumppolicy_start()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de
Date:   Wed, 19 Oct 2022 10:08:01 +0200
In-Reply-To: <20221018230728.1039524-7-kuba@kernel.org>
References: <20221018230728.1039524-1-kuba@kernel.org>
         <20221018230728.1039524-7-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-10-18 at 16:07 -0700, Jakub Kicinski wrote:
>=20
> =20
> -		if (!op.policy)
> -			return -ENODATA;
> +		if (doit.policy) {
> +			err =3D netlink_policy_dump_add_policy(&ctx->state,
> +							     doit.policy,
> +							     doit.maxattr);
> +			if (err)
> +				goto err_free_state;
> +		}
> +		if (dump.policy) {

nit: to me a blank line in places like that would be nicer, but ymmv

>  	for (i =3D 0; i < genl_get_cmd_cnt(rt); i++) {
> +		struct genl_split_ops doit, dumpit;
> +
>  		genl_get_cmd_by_index(i, rt, &op);
> =20
> -		if (op.policy) {
> +		genl_cmd_full_to_split(&doit, ctx->rt, &op, GENL_CMD_CAP_DO);
> +		genl_cmd_full_to_split(&dumpit, ctx->rt,
> +				       &op, GENL_CMD_CAP_DUMP);
> +
> +		if (doit.policy) {
> +			err =3D netlink_policy_dump_add_policy(&ctx->state,
> +							     doit.policy,
> +							     doit.maxattr);
> +			if (err)
> +				goto err_free_state;
> +		}
> +		if (dumpit.policy) {

same here

johannes
