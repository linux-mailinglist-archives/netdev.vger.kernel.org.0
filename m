Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48BA1636FF8
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 02:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiKXBrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 20:47:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiKXBrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 20:47:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AFE913CC1;
        Wed, 23 Nov 2022 17:47:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D870B82659;
        Thu, 24 Nov 2022 01:47:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A981BC433C1;
        Thu, 24 Nov 2022 01:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669254468;
        bh=30ui81BtWYvqNiwbcHBYCVSLtpLbzcn6sCg8Zp8V7Jo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oEe5viowAw+qqXHjHLZOI3bJmd9UUa2iZ8orYnG8d3+11zp+iXPMshFRNyiOXMfUn
         tqyysTJ3VXzU7ulxsBwH8pbW4oqNo0vAIDGdMiJ9igI6s4almt20oltaWnfAUVGxcc
         skHqmA07JezUiFQKazgD6zLJdhZNWWsye7qquH9eM9ZvQbPiP2udUbHmPHlV1H7dQu
         MiMgUFZ82EDOJFC1RrzDrklgJK1QA3mhxaKhlCYr2ZnTVmui7jTMkHDU8DK54fhs/a
         Klj+YmtuEt486GVvcJ32QP9R4g99DPNA181l4Uwwl98TbJsd3UXInY7bx5Y9uxWLZJ
         9u7nCGmQi8NwQ==
Date:   Wed, 23 Nov 2022 17:47:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     sdf@google.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v2 6/8] mlx4: Introduce
 mlx4_xdp_buff wrapper for xdp_buff
Message-ID: <20221123174746.418920e5@kernel.org>
In-Reply-To: <871qptuyie.fsf@toke.dk>
References: <20221121182552.2152891-1-sdf@google.com>
        <20221121182552.2152891-7-sdf@google.com>
        <874jupviyc.fsf@toke.dk>
        <CAKH8qBuF_1UoUPzh_X6FMrJ61zCNDroqSuc-Pp2uH7Q4azmN8Q@mail.gmail.com>
        <20221123111431.7b54668e@kernel.org>
        <Y3557Ecr80Y9ZD2z@google.com>
        <871qptuyie.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Nov 2022 22:55:21 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > Good idea, prototyped below, lmk if it that's not what you had in mind.
> >
> > struct xdp_buff_xsk {
> > 	struct xdp_buff            xdp;                  /*     0    56 */
> > 	u8                         cb[16];               /*    56    16 */
> > 	/* --- cacheline 1 boundary (64 bytes) was 8 bytes ago --- */ =20
>=20
> As pahole helpfully says here, xdp_buff is actually only 8 bytes from
> being a full cache line. I thought about adding a 'cb' field like this
> to xdp_buff itself, but figured that since there's only room for a
> single pointer, why not just add that and let the driver point it to
> where it wants to store the extra context data?

What if the driver wants to store multiple pointers or an integer or
whatever else? The single pointer seems quite arbitrary and not
strictly necessary.

> I am not suggesting to make anything variable-size; the 'void *drv_priv'
> is just a normal pointer. There's no changes to any typing; not sure
> where you got that from, Jakub?

Often the descriptor pointer is in the same stack frame as the xdp_buff
(or close enough). The point of adding the wrapping structure is to be
able to move the descriptor pointer into a known place and then there's
no extra store copying the descriptor pointer from one place on the
stack to another.
