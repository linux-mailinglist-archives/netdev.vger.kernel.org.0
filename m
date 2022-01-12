Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9C9848BE04
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 06:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbiALFGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 00:06:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58792 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbiALFGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 00:06:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA830B818BD
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 05:06:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4224FC36AEA;
        Wed, 12 Jan 2022 05:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641963974;
        bh=4oUXdxE9RuNCoaYDNpR7j9RgQXUCc/jantEL+h79eGA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i2VeSk7bLcAcgWmaca9yL5cpTC7YZBmy2LbLBoI+tyuxXQQV9M3sGoIA6vchGptIR
         VKP0a5sRtwJO5y1LfmVkQh+4QJo+w4zJFifcjy8T017tdicqzTGE78TDKpbHEOD0MB
         G84v2Ks7szHPavi7xX7yA1PTH8d75zcW1AEdCr864kKuJUQDghfahiIpNdZmfzd7vz
         KwwbafpJT23Gl8XLWoFfytdEBwkYJfJMIWDjfl/xvenzUuuT99VjBLI5roAquBeHIT
         LMoPUHVcK6FuTRiXKuqzIGqYtkvOthoyuz/bC6sJFbU/hFRcf/hpyw0dpa4cwrI5wE
         w9ElGtU64FKVA==
Date:   Tue, 11 Jan 2022 21:06:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kevin Bracey <kevin@bracey.fi>
Cc:     <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>,
        Jiri Pirko <jiri@resnulli.us>, Vimalkumar <j.vimal@gmail.com>
Subject: Re: [PATCH net-next] net_sched: restore "mpu xxx" handling
Message-ID: <20220111210613.55467734@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220107202249.3812322-1-kevin@bracey.fi>
References: <20220107202249.3812322-1-kevin@bracey.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Jan 2022 22:22:50 +0200 Kevin Bracey wrote:
> commit 56b765b79e9a ("htb: improved accuracy at high rates") broke
> "overhead X", "linklayer atm" and "mpu X" attributes.
> 
> "overhead X" and "linklayer atm" have already been fixed. This restores
> the "mpu X" handling, as might be used by DOCSIS or Ethernet shaping:
> 
>     tc class add ... htb rate X overhead 4 mpu 64
> 
> The code being fixed is used by htb, tbf and act_police. Cake has its
> own mpu handling. qdisc_calculate_pkt_len still uses the size table
> containing values adjusted for mpu by user space.
> 
> Fixes: 56b765b79e9a ("htb: improved accuracy at high rates")

Are you sure this worked and got broken? I can't seem to grep out any
uses of mpu in this code. commit 175f9c1bba9b ("net_sched: Add size
table for qdiscs") adds it as part of the struct but I can't find a
single use of it.
