Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F84C2C19DA
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 01:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728764AbgKXAOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 19:14:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:37578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725287AbgKXAOO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 19:14:14 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 168E420757;
        Tue, 24 Nov 2020 00:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606176853;
        bh=0AIjuF8XmpLcS4INfcXXwsD/GPc/JPaV3VUW+HQOnYg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=URT0QiJM3HQnqjs/vq3DUUATPbrX/ij4pqEgfyO2RSKdGNwitEcTk8AEHCdAZpnxY
         PU34RcCqw6xVI8nprt/p6BJ/EEWJTTxkhuXNMXFSQZj2aI/vu0TxUvGpe2FRIVXT9t
         DfPwYT0cRBoxugDlTK9b64dK0Pk4Qgr/45X++Aec=
Date:   Mon, 23 Nov 2020 16:14:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com
Subject: Re: [PATCH bpf-next v3 00/10] Introduce preferred busy-polling
Message-ID: <20201123161412.363bfb30@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201119083024.119566-1-bjorn.topel@gmail.com>
References: <20201119083024.119566-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 09:30:14 +0100 Bj=C3=B6rn T=C3=B6pel wrote:
> Performance netperf UDP_RR:
>=20
> Note that netperf UDP_RR is not a heavy traffic tests, and preferred
> busy-polling is not typically something we want to use here.
>=20
>   $ echo 20 | sudo tee /proc/sys/net/core/busy_read
>   $ netperf -H 192.168.1.1 -l 30 -t UDP_RR -v 2 -- \
>       -o min_latency,mean_latency,max_latency,stddev_latency,transaction_=
rate
>=20
> busy-polling blocking sockets:            12,13.33,224,0.63,74731.177
>=20
> I hacked netperf to use non-blocking sockets and re-ran:
>=20
> busy-polling non-blocking sockets:        12,13.46,218,0.72,73991.172
> prefer busy-polling non-blocking sockets: 12,13.62,221,0.59,73138.448
>=20
> Using the preferred busy-polling mode does not impact performance.
>=20
> The above tests was done for the 'ice' driver.

Any interest in this work form ADQ folks? I recall they were using
memcache with busy polling for their tests, it'd cool to see how much
this helps memcache on P99+ latency!
