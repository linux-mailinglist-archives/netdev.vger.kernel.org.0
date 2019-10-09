Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEAAD0584
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 04:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730041AbfJIC2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 22:28:37 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39449 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfJIC2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 22:28:36 -0400
Received: by mail-pg1-f195.google.com with SMTP id e1so403209pgj.6
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 19:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=IFYrSnqUL1eMwwPZnQNFxkzIk+OMJqWr+Es6HBbPbJ8=;
        b=LdgN+uGxOU1L5UwdUmPzr2PKnTXE2ylzuweRUP8HnPZq74aty9pDvfhrbmG1ehqKnx
         a4aDn3RpYW92F0KcaZphQ2pk4VH8ik1TuSDKl1V2seCcWoDbnqMZPK265gKMEBLaSbjH
         pbdooAy+ldHSUI+1/+xVaeYVJxafwlFEforAQ1V7iwzR5hrz/D+hi2E8+p5qS4ld65Ns
         kLl1SiKerke0IaPrQ/r/LWgBTbyKW3kxj+W+POfK8IHxUPjU2+DH6q82deysLKWk7w9X
         Z+KXEufCvf0N80J0Jz9vxtUkbHgOyfEi/4OVXmbj5oNGx5c/fpX1bQ6JUccXJCxpGbmB
         5fsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=IFYrSnqUL1eMwwPZnQNFxkzIk+OMJqWr+Es6HBbPbJ8=;
        b=NkWXKl35cxokT1XIWCQzHGq+H1/XQj6iR3DibpF/0Z9sdWqhQZ5uVXW+UIYWzfDkfJ
         Ro8WS3lirfE0Jr2DZvWjxYLKDHTMeq3w685hENXJuSS3BKA56oxg29Qdwzupiqw/TUgA
         EJ7wn5l0b/kFwvqrx6x25kXzg14xWGGqOqsGekAQHMyYIOoTJae91wi1pt5KS1N87L5P
         kBcb96QGXmYX/Qy9xHHTr+sqMvuaeN2VuMB9V2idpXuGDlplT847hhb51mQeljYV1wdi
         x9OOv7zZDGF51RUu3v59z7clzqcBVj0QGKBI1718CYEd9IIxkM3Q4ZUQ+sc9stcIg+mU
         UTQQ==
X-Gm-Message-State: APjAAAWMoxSQTY03wRPta+WKQay9zJcO435zsmAbchV4ZirC6CjNMmeH
        YOZ2v3S0EptdJioGRwd+6oP5cw==
X-Google-Smtp-Source: APXvYqwTZwZQhoKkDbeAS8exUW8Hl5vgP6tptYdg88v30CfnTSJm3Z8LTybVMFUizXDRJOMYOuuxUg==
X-Received: by 2002:a62:e206:: with SMTP id a6mr1255348pfi.245.1570588115895;
        Tue, 08 Oct 2019 19:28:35 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id g6sm464173pgk.64.2019.10.08.19.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 19:28:35 -0700 (PDT)
Date:   Tue, 8 Oct 2019 19:28:23 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>, Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net] team: call RCU read lock when walking the port_list
Message-ID: <20191008192823.52450981@cakuba.netronome.com>
In-Reply-To: <20191008141359.GE2326@nanopsycho>
References: <20191008135614.15224-1-liuhangbin@gmail.com>
        <20191008141359.GE2326@nanopsycho>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Oct 2019 16:13:59 +0200, Jiri Pirko wrote:
> Tue, Oct 08, 2019 at 03:56:14PM CEST, liuhangbin@gmail.com wrote:
> >Before reading the team port list, we need to acquire the RCU read lock.
> >Also change list_for_each_entry() to list_for_each_entry_rcu().
> >
> >Fixes: 9ed68ca0d90b ("team: add ethtool get_link_ksettings")
> >Reported-by: Paolo Abeni <pabeni@redhat.com>
> >Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> >Acked-by: Paolo Abeni <pabeni@redhat.com>  
> 
> It is not strictly needed a since rtnl is taken, but similar list
> iteration in team is designed to work without rtnl dependency.
> 
> Acked-by: Jiri Pirko <jiri@mellanox.com>

IIUC this is a cosmetic change and non-RCU iteration seems to be used
in a few places in team.c. Can we get this reposted for net-next, and
without the Fixes tag? Please keep Jiri's Ack.
