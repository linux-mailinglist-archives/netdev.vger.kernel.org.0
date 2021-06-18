Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405033AD085
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 18:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234296AbhFRQhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 12:37:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233028AbhFRQhR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 12:37:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65341613D1;
        Fri, 18 Jun 2021 16:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624034107;
        bh=Nz9SuYpOWymGWpcx+3IAIxlKg1+DoW4LSS3+6gEi+8k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lFJPgb+eh8m4mnt3ENFkrUbnURXswg0QPzt+quE32/QEEHj3rXqbVN7qeq04/z8UL
         v3oE7MuRH3yh6jKz984B4d3h67wgCu1p25RCUTuVwrA5qGCs23SbOwTaKEs4XrFay2
         cZyMjd/y4N1KnEba1g5BF+9Dro+Sv8yyvzCDnrFIc0zBqPbhkRFlT8NvNDX84PfLrG
         jdeQsLuBrZOwh9wfwUR5KF+Sq1aQOiKIqpAJJXFkGgUWOfo9GKMPBDHUf8O4S3rgrX
         0MRcfMv+pFdYJWUY4YfPborkdRomIpzMrjr80ktXW5zJWCJ7WrW6UzHgY1g2FGYjTG
         iwmQzF8NS6UcA==
Date:   Fri, 18 Jun 2021 09:35:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?w43DsWlnbw==?= Huguet <ihuguet@redhat.com>
Cc:     netdev@vger.kernel.org, Ivan Vecera <ivecera@redhat.com>,
        Edward Harold Cree <ecree@xilinx.com>,
        Dinan Gunawardena <dinang@xilinx.com>,
        Pablo Cascon <pabloc@xilinx.com>
Subject: Re: Correct interpretation of VF link-state=auto
Message-ID: <20210618093506.245a4186@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACT4oueyNoQAVW1FDcS_aus9sUqNvJhj87e_kUEkzz3azm2+pQ@mail.gmail.com>
References: <CACT4oueyNoQAVW1FDcS_aus9sUqNvJhj87e_kUEkzz3azm2+pQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Jun 2021 12:34:00 +0200 =C3=8D=C3=B1igo Huguet wrote:
> Hi,
>=20
> Regarding link-state attribute for a VF, 'man ip-link' says:
> state auto|enable|disable - set the virtual link state as seen by the
> specified VF. Setting to auto means a reflection of the PF link state,
> enable lets the VF to communicate with other VFs on this host even if
> the PF link state is down, disable causes the HW to drop any packets
> sent by the VF.
>=20
> However, I've seen that different interpretations are made about that
> explanation, especially about "auto" configuration. It is not clear if
> it should follow PF "physical link status" or PF "administrative link
> status". With the latter, `ip set PF down` would put the VF down too,
> but with the former you'd have to disconnect the physical port.

Like all legacy SR-IOV networking the correct thing to do here is clear
as mud. I'd go for the link status of the PF netdev. If the netdev
cannot pass traffic (either for administrative or physical link reasons)
then VFs shouldn't talk either. But as I said, every vendor will have their
own interpretation, and different users may expect different things...
