Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEBF5A023A
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 21:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237759AbiHXTod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 15:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiHXToc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 15:44:32 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB231792EC
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 12:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=6iV5LJYHf3uPJB7uV4npg8peLjxSSBg9gX+9L7rCPbU=;
        t=1661370270; x=1662579870; b=RbqCxR2FMcHeKdVDyscBJyqdLP+rR4J2EtTNjF1k/xU9PWG
        eigmpyuAnO5O48DQaweTRitfgUpJ13puRvhtzwXUDPjhaF0FLlLWmP5F98fGeMatciqDPo+29M9mV
        G422+0I3QGKS7veR4k6BtvCyB8EqEjsvcSeA943QmL/xbQV10GQFUguINAr67cSGHevGqF+vbBxZu
        yXTndRgpcPyXkNPagxZu0w8xlhzP4T9cQrVNZW3smPji61q8vRd39Muz4XQ3bQv7VY0EM3kcp1W+q
        JH4SXEzommrNF3rhUMiQcB1KTObBUmL6lW/ciN4/n5IT1UBGH8sbni0rk08mfaZA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oQwIZ-00GLMp-2R;
        Wed, 24 Aug 2022 21:44:23 +0200
Message-ID: <e652424b85218d370a9bbf922cf09f8b21b26822.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 3/6] genetlink: add helper for checking
 required attrs and use it in devlink
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        mkubecek@suse.cz
Date:   Wed, 24 Aug 2022 21:44:22 +0200
In-Reply-To: <20220824045024.1107161-4-kuba@kernel.org>
References: <20220824045024.1107161-1-kuba@kernel.org>
         <20220824045024.1107161-4-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-08-23 at 21:50 -0700, Jakub Kicinski wrote:
>=20
> +/* Report that a root attribute is missing */
> +#define GENL_REQ_ATTR_CHECK(info, attr) ({				\
> +	struct genl_info *__info =3D (info);				\
> +	u32 __attr =3D (attr);						\
> +	int __retval;							\
> +									\
> +	__retval =3D !__info->attrs[__attr];				\
> +	if (__retval)							\
> +		NL_SET_ERR_ATTR_MISS(__info->extack,			\
> +				     __info->userhdr ? : __info->genlhdr, \
> +				     __attr);				\
> +	__retval;							\
> +})

Not sure this needs to be a macro btw, could be an inline returning a
bool? You're not really expanding anything here, nor doing something
with strings (unlike GENL_SET_ERR_MSG for example.)

johannes
