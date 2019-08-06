Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2CC83727
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 18:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387659AbfHFQkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 12:40:40 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:43079 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732729AbfHFQkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 12:40:40 -0400
Received: by mail-wr1-f50.google.com with SMTP id p13so13978866wru.10
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 09:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=3aRi4mH8iDDVPZkOoNFk70S9mCkuvif7Eqm8r85+Hr0=;
        b=zYDDHkQ8RMo0uVhVqI9fyOSAfbiLRTSdXUKC6kZ8hIDM980dlMQHHEmMZaRbOm3rol
         EFQLfxKgRGjuhTY3PAeJDpyN0K+Rlplvr0aiSfdT5GDxvQZIG75RC89ClJ0G31LMzoyn
         V8/lBESMQVvh8Cvi+7UhfdbtKGbPOpa04S6KLNFT+Rz8PrHQsCaDsnACV9ErjCpNwaZU
         ZdLUxVfP3VTSJl+c+z0sMK6Alq++bDnodlfuTPzKNo+IW9pp/UqEtYFLm/0G5kISCZAr
         NIUGJUXAAWx21O3NpmHgLEAY/3HvhQwkFwU3GPIYgGCfOtvt6O1ZVX7PB+iB7ljCjJGa
         cTUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=3aRi4mH8iDDVPZkOoNFk70S9mCkuvif7Eqm8r85+Hr0=;
        b=UqsVYowYB2ulkj307/2+O5b+G8Wu9rrZ+OdltmmQF3i2Um+oXe/bqhaK9S7EV9EFId
         zDmVzPNU3BJHTFsib2b9+Alcbb2PG2OMkwyze8tD4rD485TIH5HeNFVz4EXHudZkazRU
         FMwOByPiEVAYxOTyP5QjtR72+HB7KILRVY4Jw/Z833tsJUZrQRMWueAaNGhRPCWL++Ej
         fdwR28cUhpzsm1WuJ4rDWwSHajPCPxqz6OceM/ysbFjlLBLozKXVQ7arRgfI3I5aTBe9
         0IG+92BsbjReDFTTFY6pYTfvlM9+uHpb84M4yFFmNbDjYUKQSDj1f7ag8JsgWAsbUqMx
         Jx9w==
X-Gm-Message-State: APjAAAXUTdTBHCtL1QJd7q67yRGH7Z8pYU+uLE8TZmRS3TLV3tlQMv7F
        WnUq5H8RUwY0X6uGLnodvVZ3llwGk5I=
X-Google-Smtp-Source: APXvYqwDJYyTz7ZbELX7ZEI49dZuS1mYRgJzId3c4rGcZsR9FS85IdVQDgTxakxDwdn8zKcxc0XetA==
X-Received: by 2002:a5d:4e8a:: with SMTP id e10mr5995548wru.26.1565109637980;
        Tue, 06 Aug 2019 09:40:37 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id l8sm170816639wrg.40.2019.08.06.09.40.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 09:40:37 -0700 (PDT)
Date:   Tue, 6 Aug 2019 18:40:36 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, mlxsw@mellanox.com,
        jakub.kicinski@netronome.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, mkubecek@suse.cz,
        stephen@networkplumber.org, daniel@iogearbox.net,
        brouer@redhat.com, eric.dumazet@gmail.com
Subject: [RFC] implicit per-namespace devlink instance to set kernel resource
 limitations
Message-ID: <20190806164036.GA2332@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all.

I just discussed this with DavidA and I would like to bring this to
broader audience. David wants to limit kernel resources in network
namespaces, for example fibs, fib rules, etc.

He claims that devlink api is rich enough to program this limitations
as it already does for mlxsw hw resources for example. If we have this
api for hardware, why don't to reuse it for the kernel and it's
resources too?

So the proposal is to have some new device, say "kernelnet", that would
implicitly create per-namespace devlink instance. This devlink
instance would be used to setup resource limits. Like:

devlink resource set kernelnet path /IPv4/fib size 96
devlink -N ns1name resource set kernelnet path /IPv6/fib size 100
devlink -N ns2name resource set kernelnet path /IPv4/fib-rules size 8

To me it sounds a bit odd for kernel namespace to act as a device, but
thinking about it more, it makes sense. Probably better than to define
a new api. User would use the same tool to work with kernel and hw.

Also we can implement other devlink functionality, like dpipe.
User would then have visibility of network pipeline, tables,
utilization, etc. It is related to the resources too.

What do you think?

Jiri
