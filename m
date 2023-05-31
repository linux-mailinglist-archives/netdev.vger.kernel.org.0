Return-Path: <netdev+bounces-6932-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EDB6718D7C
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 23:49:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8877281607
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 21:49:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 051E23D3BA;
	Wed, 31 May 2023 21:49:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65F619E7C
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 21:49:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD04C433EF;
	Wed, 31 May 2023 21:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685569787;
	bh=aGfdDi3uZnFkx6zkAyqIM68qZh/YHY0DCRpb2p1GQbk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FwdoOeCB63lBeSMjLIqrU3Yyd+wOuPyWsYHkQHketH1muZb8vLLUrsTZEAJyq9wo1
	 psA9yX89HZl14Mu0KftmkiiwfYtx5IAYOnTAbZAz8nrJw4A9uXwosaC9EXXeDkLvFR
	 M8yykpXyL1+bJRYak6xkEFefjCcZURTSBxao+TyK+E0n84nKTSGMInWSBBELvzCvQ2
	 BuK6j1EuVAQlgHOeKgzV07VLd2QLhdmiJrv9p3sNOnl//7mnvIhBl78pho/Nm29zkA
	 SWO7TSy+W8u7YOfi04pSpFbZzNleaRJ3+am9v1zmCoHpCQnS5ENFNcraZScor/kO/2
	 rE3wl1GtVe21g==
Date: Wed, 31 May 2023 14:49:46 -0700
From: Saeed Mahameed <saeed@kernel.org>
To: =?iso-8859-1?Q?C=E9dric?= Le Goater <clegoate@redhat.com>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>, Shay Drory <shayd@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>, Eli Cohen <elic@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org, Mark Brown <broonie@kernel.org>,
	Simon Horman <simon.horman@corigine.com>,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v2] net/mlx5: Fix setting of irq->map.index for
 static IRQ case
Message-ID: <ZHfA+i4E3SykRT4O@x130>
References: <20230531084856.2091666-1-schnelle@linux.ibm.com>
 <cdd8953e-2187-32f7-bb3c-aaf54581775d@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cdd8953e-2187-32f7-bb3c-aaf54581775d@redhat.com>

On 31 May 11:38, Cédric Le Goater wrote:
>On 5/31/23 10:48, Niklas Schnelle wrote:
>>When dynamic IRQ allocation is not supported all IRQs are allocated up
>>front in mlx5_irq_table_create() instead of dynamically as part of
>>mlx5_irq_alloc(). In the latter dynamic case irq->map.index is set
>>via the mapping returned by pci_msix_alloc_irq_at(). In the static case
>>and prior to commit 1da438c0ae02 ("net/mlx5: Fix indexing of mlx5_irq")
>>irq->map.index was set in mlx5_irq_alloc() twice once initially to 0 and
>>then to the requested index before storing in the xarray. After this
>>commit it is only set to 0 which breaks all other IRQ mappings.
>>
>>Fix this by setting irq->map.index to the requested index together with
>>irq->map.virq and improve the related comment to make it clearer which
>>cases it deals with.
>>
>>Tested-by: Mark Brown <broonie@kernel.org>
>>Reviewed-by: Mark Brown <broonie@kernel.org>
>>Reviewed-by: Simon Horman <simon.horman@corigine.com>
>>Reviewed-by: Eli Cohen <elic@nvidia.com>
>>Fixes: 1da438c0ae02 ("net/mlx5: Fix indexing of mlx5_irq")
>>Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
>

Applied to net-mlx5. 

Thanks.



