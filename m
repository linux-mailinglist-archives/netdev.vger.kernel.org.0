Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F83F1E7570
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 07:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725855AbgE2FfL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 29 May 2020 01:35:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:15353 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725308AbgE2FfK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 01:35:10 -0400
IronPort-SDR: Nr8GJnKLkkq7JkdDtxsHPUTabbtSHn5N8zNfabu2iS6Fnqwq46jL9Zi8mtlWbWzaJ9biDdTVph
 n32Rg9iHNCew==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 22:35:10 -0700
IronPort-SDR: x400dgFeBGYYcZf6at12iSswF0xD65yizzDfsHkKQorANkWQH8dBDMs/iN7EFBJpejnqYz2AVt
 zvwbRSCrA5YA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="302723578"
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by fmsmga002.fm.intel.com with ESMTP; 28 May 2020 22:35:09 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.61]) by
 ORSMSX110.amr.corp.intel.com ([169.254.10.119]) with mapi id 14.03.0439.000;
 Thu, 28 May 2020 22:35:09 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>
Subject: RE: [PATCH net-next v3] ice: Replace one-element arrays with
 flexible-arrays
Thread-Topic: [PATCH net-next v3] ice: Replace one-element arrays with
 flexible-arrays
Thread-Index: AQHWNDACNpPEgN+IHEW5ZY2UVT3OQ6i+jFOg
Date:   Fri, 29 May 2020 05:35:09 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D94044986DE746@ORSMSX112.amr.corp.intel.com>
References: <20200527141119.GA30849@embeddedor>
In-Reply-To: <20200527141119.GA30849@embeddedor>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Gustavo A. R. Silva <gustavoars@kernel.org>
> Sent: Wednesday, May 27, 2020 07:11
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; David S. Miller
> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>
> Cc: intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Gustavo A. R. Silva <gustavo@embeddedor.com>;
> Kees Cook <keescook@chromium.org>
> Subject: [PATCH net-next v3] ice: Replace one-element arrays with flexible-
> arrays
> 
> The current codebase makes use of one-element arrays in the following
> form:
> 
> struct something {
>     int length;
>     u8 data[1];
> };
> 
> struct something *instance;
> 
> instance = kmalloc(sizeof(*instance) + size, GFP_KERNEL);
> instance->length = size;
> memcpy(instance->data, source, size);
> 
> but the preferred mechanism to declare variable-length types such as these
> ones is a flexible array member[1][2], introduced in C99:
> 
> struct foo {
>         int stuff;
>         struct boo array[];
> };
> 
> By making use of the mechanism above, we will get a compiler warning in case
> the flexible array does not occur last in the structure, which will help us prevent
> some kind of undefined behavior bugs from being inadvertently introduced[3]
> to the codebase from now on. So, replace the one-element array with a
> flexible-array member.
> 
> Also, make use of the offsetof() helper in order to simplify some macros and
> properly calculate the size of the structures that contain flexible-array members.
> 
> This issue was found with the help of Coccinelle and, audited _manually_.
> 
> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> [2] https://github.com/KSPP/linux/issues/21
> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
[Kirsher, Jeffrey T] 

Thanks Gustavo, but we (or I should say Bruce Allan) already has a patch to resolve this,
and is a bit more thorough.  I will make sure you get CC'd on the patch, for your review.

> ---
> Changes in v3:
>  - We still can simply the code even more by using offsetof() just once. :)
> 
> Changes in v2:
>  - Use offsetof(struct ice_aqc_sw_rules_elem, pdata) instead of
>    sizeof(struct ice_aqc_sw_rules_elem) - sizeof(((struct ice_aqc_sw_rules_elem
> *)0)->pdata)
>  - Update changelog text.
> 
>  .../net/ethernet/intel/ice/ice_adminq_cmd.h   |  6 ++---
>  drivers/net/ethernet/intel/ice/ice_switch.c   | 23 ++++++-------------
>  2 files changed, 10 insertions(+), 19 deletions(-)
> 
