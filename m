Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10BC46BAF1
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 13:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbhLGMYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 07:24:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:4084 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230107AbhLGMYv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 07:24:51 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="235077040"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="235077040"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 04:21:21 -0800
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="679424774"
Received: from lahna.fi.intel.com (HELO lahna) ([10.237.72.163])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 04:21:14 -0800
Received: by lahna (sSMTP sendmail emulation); Tue, 07 Dec 2021 14:21:05 +0200
Date:   Tue, 7 Dec 2021 14:21:05 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] thunderbolt: xdomain: Avoid potential stack OOB read
Message-ID: <Ya9Rsfos46i8Rcpc@lahna>
References: <20211207063413.2698788-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207063413.2698788-1-keescook@chromium.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 10:34:13PM -0800, Kees Cook wrote:
> tb_xdp_properties_changed_request() was calling tb_xdp_handle_error() with
> a struct tb_xdp_properties_changed_response on the stack, which does not
> have the "error" field present when cast to struct tb_xdp_error_response.
> This was detected when building with -Warray-bounds:
> 
> drivers/thunderbolt/xdomain.c: In function 'tb_xdomain_properties_changed':
> drivers/thunderbolt/xdomain.c:226:22: error: array subscript 'const struct tb_xdp_error_response[0]' is partly outside array bounds of 'struct tb_xdp_properties_changed_response[1]' [-Werror=array-bounds]
>   226 |         switch (error->error) {
>       |                 ~~~~~^~~~~~~
> drivers/thunderbolt/xdomain.c:448:51: note: while referencing 'res'
>   448 |         struct tb_xdp_properties_changed_response res;
>       |                                                   ^~~
> 
> Add union containing struct tb_xdp_error_response to structures passed
> to tb_xdp_handle_error(), so that the "error" field will be present.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Applied, thanks!
