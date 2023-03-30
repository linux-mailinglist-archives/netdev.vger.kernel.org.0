Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF34C6D0CCD
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 19:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbjC3RaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 13:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232418AbjC3RaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 13:30:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBD9CDF9
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 10:30:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CFFC620E3
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 17:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7573C433EF;
        Thu, 30 Mar 2023 17:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680197406;
        bh=oyxNFRBMn6gw7+xMBQskFmLpUQLtD2V65VK7A/Jnk34=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JjA7NuQ421ZoNPQPn0QygPQVkhnQMZP7EyAe9WqfLqDYCl2KZ2brrUZ6JTTjYtuso
         U3JVyOfS1zW39rkb7JNylRMkQtRLobONSa/Ol6y1qOSkDyioB13W8SH4IoevGSI3t0
         82CRj9G/GKlA2HSS0t96zmLOJCLuNOeac5Te8EC7fwfVXTU1MKG9yR3zDYIXvba0ol
         y1WAO7khFscAgGVHHUyL8GCOoRFZh9Vi4Nw4JT3lKJk8xv/QGyVE/KUjeJxhLTcMPz
         yuwz3R9EuK5KUbuTMMQoHGsn6lVKNNI6wq2AZjSK4UicEPCD5YDcTr+V++JH+ToFxS
         gNYlFrDfpHyZQ==
Date:   Thu, 30 Mar 2023 10:30:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yinjun Zhang <yinjun.zhang@corigine.com>
Cc:     Louis Peens <louis.peens@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: Re: [PATCH net-next 2/2] nfp: separate the port's upper state with
 lower phy state
Message-ID: <20230330103004.2b64c791@kernel.org>
In-Reply-To: <DM6PR13MB3705CA9B36F8B14C4F5E961BFC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20230329144548.66708-1-louis.peens@corigine.com>
        <20230329144548.66708-3-louis.peens@corigine.com>
        <20230329122422.52f305f5@kernel.org>
        <DM6PR13MB37057AA65195F85CC16E34BCFC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
        <20230329194126.268ffd61@kernel.org>
        <DM6PR13MB3705B02A219219A4897A66C5FC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
        <20230329201225.421e2a84@kernel.org>
        <DM6PR13MB37058BF030C43EAFA45DE4CAFC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
        <20230329210048.0054e01b@kernel.org>
        <DM6PR13MB3705CA9B36F8B14C4F5E961BFC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Mar 2023 05:55:22 +0000 Yinjun Zhang wrote:
> > This patch is very unlikely to be accepted upstream.
> > Custom knobs to do weird things are really not our favorite.  
> 
> As I said, it's not so custom, but rather very common.

Just to be 100% clear, if you send v2 of this patch please include:

Nacked-by: Jakub Kicinski <kuba@kernel.org>
