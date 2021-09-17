Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0C540F152
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 06:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244637AbhIQEa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 00:30:58 -0400
Received: from smtp1.emailarray.com ([65.39.216.14]:43437 "EHLO
        smtp1.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbhIQEa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 00:30:57 -0400
Received: (qmail 3104 invoked by uid 89); 17 Sep 2021 04:29:35 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMQ==) (POLARISLOCAL)  
  by smtp1.emailarray.com with SMTP; 17 Sep 2021 04:29:35 -0000
Date:   Thu, 16 Sep 2021 21:29:33 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] ptp: ocp: Avoid operator precedence warning in
 ptp_ocp_summary_show()
Message-ID: <20210917042933.d42m5ijbiiqrctxp@bsd-mbp.dhcp.thefacebook.com>
References: <20210916194351.3860836-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916194351.3860836-1-nathan@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 16, 2021 at 12:43:51PM -0700, Nathan Chancellor wrote:
> Clang warns twice:
> 
> drivers/ptp/ptp_ocp.c:2065:16: error: operator '?:' has lower precedence
> than '&'; '&' will be evaluated first
> [-Werror,-Wbitwise-conditional-parentheses]
>                            on & map ? " ON" : "OFF", src);
>                            ~~~~~~~~ ^
> drivers/ptp/ptp_ocp.c:2065:16: note: place parentheses around the '&'
> expression to silence this warning
>                            on & map ? " ON" : "OFF", src);
>                                     ^
>                            (       )
> drivers/ptp/ptp_ocp.c:2065:16: note: place parentheses around the '?:'
> expression to evaluate it first
>                            on & map ? " ON" : "OFF", src);
>                                     ^
> 
> It is clearly intentional that the bitwise operation be done before the
> ternary operation so add the parentheses as it suggests to fix the
> warning.

Actually, the correct fix is to change '&' to '&&', so a logical
operation is done instead of an arithmetic operation.  I believe
this will silence the warning from clang.
-- 
Jonathan
