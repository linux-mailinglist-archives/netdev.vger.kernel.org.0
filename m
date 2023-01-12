Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2921466725C
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 13:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbjALMiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 07:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbjALMiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 07:38:52 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4214549171
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 04:38:51 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 326F520519;
        Thu, 12 Jan 2023 13:38:49 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Jbt7adnHvcOg; Thu, 12 Jan 2023 13:38:48 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B0BAF200AC;
        Thu, 12 Jan 2023 13:38:48 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id AB9CB80004A;
        Thu, 12 Jan 2023 13:38:48 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 12 Jan 2023 13:38:43 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 12 Jan
 2023 13:38:48 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id C50473182953; Thu, 12 Jan 2023 13:38:47 +0100 (CET)
Date:   Thu, 12 Jan 2023 13:38:47 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Benedict Wong <benedictwong@google.com>
CC:     <netdev@vger.kernel.org>, <nharold@google.com>,
        <lorenzo@google.com>
Subject: Re: [PATCH v3 ipsec] Fix XFRM-I support for nested ESP tunnels
Message-ID: <20230112123847.GB438791@gauss3.secunet.de>
References: <20230105212812.2028732-1-benedictwong@google.com>
 <20230105212812.2028732-2-benedictwong@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230105212812.2028732-2-benedictwong@google.com>
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

On Thu, Jan 05, 2023 at 09:28:12PM +0000, Benedict Wong wrote:
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

Applied, thanks a lot Ben!
