Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3985EADD2
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 19:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbiIZROe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 13:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbiIZRNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 13:13:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0846557BEE
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 09:25:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99A6560FCC
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 16:25:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F19C433C1;
        Mon, 26 Sep 2022 16:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664209549;
        bh=HQGB4nJ40ifnVorrSiaMFgpxEGGg7oJdpjzUsEZybsE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nGax3/n5S57/PQ0eIlm2A68RGIA7QMv6CJnl9q2GQHZWH/1NG8KTFiWt12gH03NfM
         bK9kGTmAbIJn83svRx0AE8xyJTLOBhsbcWdE8NIjWjdYGzyHURbdeCNUr/ucErvWXw
         9Cco67J7ZnVob0GyHHRUWNY7NFlcS6O45tqJUfeQt1hDcL7UkTYAjAV1QYagE2io8K
         OQsMWIxpgOU2+RIS/tyNYGk7Dms4pn51nt4js0p0xEO+Fj+nZxtH9pgCx1G3I8Rzlv
         IMZYFHillEbqu5cl9QXnyY28wwdajuFtN7Uy11+QNpQKED5G1nTaWugzyOibq/0wYZ
         JYvhlfqZVRYWA==
Date:   Mon, 26 Sep 2022 09:25:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yinjun Zhang <yinjun.zhang@corigine.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Fei Qin <fei.qin@corigine.com>
Subject: Re: [PATCH net-next 2/3] nfp: add support for link auto negotiation
Message-ID: <20220926092547.4f2a484e@kernel.org>
In-Reply-To: <20220924024530.GA8804@nj-rack01-04.nji.corigine.com>
References: <20220921121235.169761-1-simon.horman@corigine.com>
        <20220921121235.169761-3-simon.horman@corigine.com>
        <20220922180040.50dd1af0@kernel.org>
        <DM6PR13MB3705B174455A7E5225CAF996FC519@DM6PR13MB3705.namprd13.prod.outlook.com>
        <20220923062114.7db02bce@kernel.org>
        <20220923154157.GA13912@nj-rack01-04.nji.corigine.com>
        <20220923172410.5af0cc9f@kernel.org>
        <20220924024530.GA8804@nj-rack01-04.nji.corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 24 Sep 2022 10:45:30 +0800 Yinjun Zhang wrote:
> On Fri, Sep 23, 2022 at 05:24:10PM -0700, Jakub Kicinski wrote:
> > > Because the value of sp_indiff depends on the loaded application
> > > firmware, please ref to previous commit:
> > > 2b88354d37ca ("nfp: check if application firmware is indifferent to port speed")  
> > 
> > AFAICT you check if it's flower, you can check that in the main code,
> > the app id is just a symbol, right?  
> 
> Not only check if it's flower, but also check if it's sp_indiff when
> it's not flower by parsing the tlv caps.

Seems bogus. The speed independence is a property of the whole FW image,
you record it in the pf structure.
