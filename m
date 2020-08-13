Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A198D244005
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 22:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgHMUq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 16:46:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:50584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726192AbgHMUq3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Aug 2020 16:46:29 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBFAD20675;
        Thu, 13 Aug 2020 20:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597351589;
        bh=uehgvCNV3BFvFyx84FWaaRHqZkxJXKC6eo2Ocl0e9CE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qSTWHfncZiCfp+zQHvyQj0mIPNRc2tnWbFIUzawYrmODh4lNB58BXbgFQNCZkvaF7
         AnRxxiyEuuE9B9YmLde4KFRzP/EH5fjBfeDdEu/syvoKTEqrMv5jViSRxR2BuxNUE2
         xLutx0S278Avv/khFCMG3xZOJak4nj/gx6A4cYwA=
Date:   Thu, 13 Aug 2020 13:46:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefan Assmann <sassmann@kpanic.de>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        davem@davemloft.net, jeffrey.t.kirsher@intel.com,
        lihong.yang@intel.com
Subject: Re: [PATCH v2] i40e: fix return of uninitialized aq_ret in
 i40e_set_vsi_promisc
Message-ID: <20200813134627.4dd521cc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200813112638.12699-1-sassmann@kpanic.de>
References: <20200813112638.12699-1-sassmann@kpanic.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Aug 2020 13:26:38 +0200 Stefan Assmann wrote:
> drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c: In function =E2=80=98=
i40e_set_vsi_promisc=E2=80=99:
> drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c:1176:14: error: =E2=80=
=98aq_ret=E2=80=99 may be used uninitialized in this function [-Werror=3Dma=
ybe-uninitialized]
>   i40e_status aq_ret;
>=20
> In case the code inside the if statement and the for loop does not get
> executed aq_ret will be uninitialized when the variable gets returned at
> the end of the function.
>=20
> Avoid this by changing num_vlans from int to u16, so aq_ret always gets
> set. Making this change in additional places as num_vlans should never
> be negative.
>=20
> Fixes: 37d318d7805f ("i40e: Remove scheduling while atomic possibility")
> Signed-off-by: Stefan Assmann <sassmann@kpanic.de>

Acked-by: Jakub Kicinski <kuba@kernel.org>

Good enough - in general unless you're trying to save space using types
other than unsigned int is not really worth it, and can slow the code
down - since 2B arithmetic is actually slowest on modern CPUs. But it's
not a fast path, so doesn't matter much.
