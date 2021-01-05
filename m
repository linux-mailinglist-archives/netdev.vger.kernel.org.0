Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C360E2EA656
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 09:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbhAEIMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 03:12:03 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:39416 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725766AbhAEIMC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 03:12:02 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 101E020082;
        Tue,  5 Jan 2021 09:11:21 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hIQUkGXe1nHz; Tue,  5 Jan 2021 09:11:08 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id E9B8C2006F;
        Tue,  5 Jan 2021 09:11:08 +0100 (CET)
Received: from mbx-dresden-01.secunet.de (10.53.40.199) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 5 Jan 2021 09:11:03 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-dresden-01.secunet.de
 (10.53.40.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Tue, 5 Jan 2021
 09:11:03 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 66C7D3180C94; Tue,  5 Jan 2021 09:11:02 +0100 (CET)
Date:   Tue, 5 Jan 2021 09:11:02 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>
CC:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <shuah@kernel.org>, <fw@strlen.de>
Subject: Re: [PATCH] selftests: xfrm: fix test return value override issue in
 xfrm_policy.sh
Message-ID: <20210105081102.GI3576117@gauss3.secunet.de>
References: <20201230095204.21467-1-po-hsu.lin@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201230095204.21467-1-po-hsu.lin@canonical.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-dresden-01.secunet.de (10.53.40.199)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 30, 2020 at 05:52:04PM +0800, Po-Hsu Lin wrote:
> When running this xfrm_policy.sh test script, even with some cases
> marked as FAIL, the overall test result will still be PASS:
> 
> $ sudo ./xfrm_policy.sh
> PASS: policy before exception matches
> FAIL: expected ping to .254 to fail (exceptions)
> PASS: direct policy matches (exceptions)
> PASS: policy matches (exceptions)
> FAIL: expected ping to .254 to fail (exceptions and block policies)
> PASS: direct policy matches (exceptions and block policies)
> PASS: policy matches (exceptions and block policies)
> FAIL: expected ping to .254 to fail (exceptions and block policies after hresh changes)
> PASS: direct policy matches (exceptions and block policies after hresh changes)
> PASS: policy matches (exceptions and block policies after hresh changes)
> FAIL: expected ping to .254 to fail (exceptions and block policies after hthresh change in ns3)
> PASS: direct policy matches (exceptions and block policies after hthresh change in ns3)
> PASS: policy matches (exceptions and block policies after hthresh change in ns3)
> FAIL: expected ping to .254 to fail (exceptions and block policies after htresh change to normal)
> PASS: direct policy matches (exceptions and block policies after htresh change to normal)
> PASS: policy matches (exceptions and block policies after htresh change to normal)
> PASS: policies with repeated htresh change
> $ echo $?
> 0
> 
> This is because the $lret in check_xfrm() is not a local variable.
> Therefore when a test failed in check_exceptions(), the non-zero $lret
> will later get reset to 0 when the next test calls check_xfrm().
> 
> With this fix, the final return value will be 1. Make it easier for
> testers to spot this failure.
> 
> Fixes: 39aa6928d462d0 ("xfrm: policy: fix netlink/pf_key policy lookups")
> Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>

Applied to the ipsec tree, thanks!
