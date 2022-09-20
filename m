Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7466D5BEA99
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 17:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbiITPzs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 20 Sep 2022 11:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbiITPzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 11:55:46 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD13558507
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 08:55:43 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-670-bgoSSUozMEKEBKeXfUGgZw-1; Tue, 20 Sep 2022 11:55:39 -0400
X-MC-Unique: bgoSSUozMEKEBKeXfUGgZw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 19B8B185A7A3;
        Tue, 20 Sep 2022 15:55:39 +0000 (UTC)
Received: from hog (unknown [10.39.194.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F9B41121314;
        Tue, 20 Sep 2022 15:55:37 +0000 (UTC)
Date:   Tue, 20 Sep 2022 17:55:28 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, steffen.klassert@secunet.com
Subject: Re: [PATCH ipsec-next 1/7] xfrm: add extack support to
 verify_newsa_info
Message-ID: <YynicFZpq2Z64u86@hog>
References: <cover.1663103634.git.sd@queasysnail.net>
 <b492239e903e8491abfd91178b572b59a48851e3.1663103634.git.sd@queasysnail.net>
 <20220919170038.23b6d58e@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20220919170038.23b6d58e@kernel.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022-09-19, 17:00:38 -0700, Jakub Kicinski wrote:
> On Wed, 14 Sep 2022 19:04:00 +0200 Sabrina Dubroca wrote:
> >  	case IPPROTO_COMP:
> > +		if (!attrs[XFRMA_ALG_COMP]) {
> > +			NL_SET_ERR_MSG(extack, "Missing required attribute for COMP: COMP");
> > +			goto out;
> > +		}
> 
> Did NL_SET_ERR_ATTR_MISS() make it to the xfrm tree?

No, it hasn't. Thanks for the note, I hadn't seen those patches.

It would only solve part of the problem here, since some cases need
one of two possible attributes (AH needs AUTH or AUTH_TRUNC, ESP needs
AEAD or CRYPT).

In this particular case, it's also a bit confusing because which
attribute is required (or not allowed) depends on other parts of the
configuration, so there isn't a way to express most of it outside of
strings -- short of having netlink policies or extacks that can
describe logical formulas, I guess.

-- 
Sabrina

