Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40BFF64C3E7
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 07:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237353AbiLNGjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 01:39:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiLNGje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 01:39:34 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 230F926AD2
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 22:39:33 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 269AD2052E;
        Wed, 14 Dec 2022 07:39:31 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id O5WdmoxMk2fP; Wed, 14 Dec 2022 07:39:30 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id A3E0020491;
        Wed, 14 Dec 2022 07:39:30 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 9CD4780004A;
        Wed, 14 Dec 2022 07:39:30 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 14 Dec 2022 07:39:30 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 14 Dec
 2022 07:39:30 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id C14A43182967; Wed, 14 Dec 2022 07:39:29 +0100 (CET)
Date:   Wed, 14 Dec 2022 07:39:29 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Benedict Wong <benedictwong@google.com>
CC:     <netdev@vger.kernel.org>, <nharold@google.com>,
        <lorenzo@google.com>
Subject: Re: [PATCH v2 ipsec] Fix XFRM-I support for nested ESP tunnels
Message-ID: <20221214063929.GO704954@gauss3.secunet.de>
References: <20221123033456.1187746-1-benedictwong@google.com>
 <20221123033456.1187746-2-benedictwong@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221123033456.1187746-2-benedictwong@google.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23, 2022 at 03:34:55AM +0000, Benedict Wong wrote:
> This change adds support for nested IPsec tunnels by ensuring that
> XFRM-I verifies existing policies before decapsulating a subsequent
> policies. Addtionally, this clears the secpath entries after policies
> are verified, ensuring that previous tunnels with no-longer-valid
> do not pollute subsequent policy checks.
> 
> This is necessary especially for nested tunnels, as the IP addresses,
> protocol and ports may all change, thus not matching the previous
> policies. In order to ensure that packets match the relevant inbound
> templates, the xfrm_policy_check should be done before handing off to
> the inner XFRM protocol to decrypt and decapsulate.
> 
> Notably, raw ESP/AH packets did not perform policy checks inherently,
> whereas all other encapsulated packets (UDP, TCP encapsulated) do policy
> checks after calling xfrm_input handling in the respective encapsulation
> layer.
> 
> Test: Verified with additional Android Kernel Unit tests
> Signed-off-by: Benedict Wong <benedictwong@google.com>
> ---
>  net/xfrm/xfrm_interface.c | 54 ++++++++++++++++++++++++++++++++++++---

Sorry for the late reply, I've overlooked this on the list.
Please Cc me directly for IPsec patches.

net/xfrm/xfrm_interface.c was renamed to xfrm_interface_core.c,
so your patch does not apply. Can you please respin the patch?

Thanks!
