Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAEF62FD18E
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 14:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731218AbhATMwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 07:52:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39380 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732250AbhATMYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 07:24:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611145387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=91j6yNO0RRALEQ9lXy2h4Mwo9Jhaxoqv3sZ7kde2+7o=;
        b=AVlJSTnQE7t6fj7as/JvEQzMfSBaQWt6yGRRBrTwVkNMXAMP/XDFhZ8Wj+Qm01K87heseJ
        ac2oftvJ2U4fUimtGEuLmZBIgqvaJvIg3qfiiehevFKuz7dRawDxl1Q4bxa2rdBnmkba7M
        3HZJFgUz8T2SVuJcuLfJapDEg+jQ49E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-566-heeaAHYEM5aR4sYZFVnpCA-1; Wed, 20 Jan 2021 07:23:04 -0500
X-MC-Unique: heeaAHYEM5aR4sYZFVnpCA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 362E5C7405;
        Wed, 20 Jan 2021 12:23:03 +0000 (UTC)
Received: from ceranb (unknown [10.40.194.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B01E12BFE4;
        Wed, 20 Jan 2021 12:23:01 +0000 (UTC)
Date:   Wed, 20 Jan 2021 13:23:00 +0100
From:   Ivan Vecera <ivecera@redhat.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net] team: fix deadlock during setting of MTU
Message-ID: <20210120132300.757b91b3@ceranb>
In-Reply-To: <20210115092405.29e8ff8f@ceranb>
References: <20210114115506.1713330-1-ivecera@redhat.com>
        <174c673c87fea15e832b795140addb70827818ff.camel@kernel.org>
        <20210115092405.29e8ff8f@ceranb>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jan 2021 09:24:05 +0100
Ivan Vecera <ivecera@redhat.com> wrote:

> > according to your explanation in the commit message the team->lock
> > mutex will be also taken under this rcu lock, so this is bad even
> > if dev_set_mtu does not sleep.
> >   
> Hmm, you are right... btw do we need to take this mutex at this place?
> 
> team_change_mtu() is protected by RTNL, team_device_event() as a netdevice
> notifier as well... and team_{add,del}_slave() that modify port list
> also.
> 
> Thoughts?

After private discussion with Jiri, this is no-go as he would not like to
introduce a dependency on RTNL into team driver. The other solution is
to postpone features calculation in certain cases... the patch follows.

Ivan

