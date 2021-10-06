Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB83423845
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 08:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237417AbhJFGkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 02:40:12 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:45492 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237710AbhJFGjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 02:39:44 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 066AA2031D;
        Wed,  6 Oct 2021 06:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1633502271; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YUhrPyxwspHr5YRHpAL0BV3Fg61GWhmW1fQW9jXBNiE=;
        b=SISaHGHUrfMpNrl6FJc3gljLMfSiq6G3Ql4IMRwefWPk7xsnLnz0GVN3HE19K1HmncafdB
        WFDKdYG4+6uuAZbvpxbYIt4QlqSHCZtA1NnPOvvG8HnbE0ND/Uf4B/AO7zXonUZ572HfWy
        xLy23XrVffMLsGfZwdwzF4Fu3cn+1q0=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 20598A3B89;
        Wed,  6 Oct 2021 06:37:48 +0000 (UTC)
Date:   Wed, 6 Oct 2021 08:37:47 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        gregkh@linuxfoundation.org, ebiederm@xmission.com,
        stephen@networkplumber.org, herbert@gondor.apana.org.au,
        juri.lelli@redhat.com, netdev@vger.kernel.org,
        Jiri Bohac <jbohac@suse.cz>
Subject: Re: [RFC PATCH net-next 0/9] Userspace spinning on net-sysfs access
Message-ID: <YV1EO9dsVSwWW7ua@dhcp22.suse.cz>
References: <20210928125500.167943-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928125500.167943-1-atenart@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 28-09-21 14:54:51, Antoine Tenart wrote:
> Hello,

Hi,
thanks for posting this. Coincidentally we have come across a similar
problem as well just recently.

> What made those syscalls to spin is the following construction (which is
> found a lot in net sysfs and sysctl code):
> 
>   if (!rtnl_trylock())
>           return restart_syscall();

One of our customer is using Prometeus (https://github.com/prometheus/prometheus)
for monitoring and they have noticed that running several instances of
node-exporter can lead to a high CPU utilization. After some
investigation it has turned out that most instances are busy looping on
on of the sysfs files while one instance is processing sysfs speed file
for mlx driver which performs quite a convoluted set of operations (send
commands to the lower layers via workqueues) to talk to the device to
get the information.

The problem becomes more visible with more instance of node-exporter
running at parallel. This results in some monitoring alarms at the said
machine because the high CPU utilization is not expected.

I would appreciate if you CC me on next versions of this patchset.

Thankis for working on this!
-- 
Michal Hocko
SUSE Labs
