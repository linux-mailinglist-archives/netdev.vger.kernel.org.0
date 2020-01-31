Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE0314EE0E
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 14:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728948AbgAaN6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 08:58:46 -0500
Received: from mail-wr1-f50.google.com ([209.85.221.50]:34950 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728500AbgAaN6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 08:58:46 -0500
Received: by mail-wr1-f50.google.com with SMTP id g17so8759506wro.2
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 05:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arangodb.com; s=google;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=NbNYmU7TGBK3dRZumVcgTTsq4mqLZhmqNa9FXJpcous=;
        b=JexBGKiwKISWHg0ESHB6vaxxaI7LgsY9bEoNVUl8/8r/TmVHH+6Q9D6MSI3jMd0VB9
         Iirj/c3WAgnw9SbNuFlfS89ACUTWED6MUqMK4idJHBIx+XxglRj0D00Sd4f3snh7T5uy
         UVFFSkf3ewcZ7ZckUXL3/rBTtH+Ere0dNdTPHrE5NAa3nGauFVwchYh1oHl/2dCd3g2A
         +GENUhZO3Es7dzNKp+UGDINGHHBWfcMn2t1HfQm28I/2juxtKzL5wJpoTsPPmSTq8SL7
         NYlIBAhQZRf8ZhJBX5Z3x60P/Zc4irnrpObVvqtS/Qoi8s/laNK/ma8Jx87FLMMJve1j
         Op8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=NbNYmU7TGBK3dRZumVcgTTsq4mqLZhmqNa9FXJpcous=;
        b=Mv9o8t8xnog8a6O38Tzy/HxVw5l9Lzpz3cFSBL3B/ScKJm0NZw/ps7Ic338USmKF3g
         owfOVoGwxOitXtuZ4g5JFu6sfBZB6dLEQ8iutNUmtyLNAYzEUIkbJbAXLAQEWWDLFffW
         7OB83xDakCANQEEUci5t3bWQ22LwV6oJRGywRI15zBA2CpMVavVNGEBeTPOLRWwobOc0
         c5WvxlvdFPqhJb16XbbSOPWLjpK182qM1TXjc01WlDeo0G4OgIAPeWpzuFD+FE9sl/kX
         JvZvFlGs426nfk7dOj7pTsztASjZl9ai7fcKne7FnZ3/AivpQBS9S1Skz6yIClFG0FRR
         uHgg==
X-Gm-Message-State: APjAAAVUej+r29pWixtIdynt4Xl9I7lYH54ncJsTdmjOKz8TlNQoMfu8
        OVIxyCcLaLclIPJ209sivSRdiKNXDaBJEIXhmG0SQjhv2M9PXmNDPqkJFS2VvKgF0Hzc9iVIfyZ
        wfo6D/SW00Mah+E3W6x21OAXUHpZdC7r/rL6eJR8a9DAhLHjnw+BSVJEX+lyMgA==
X-Google-Smtp-Source: APXvYqyPBX+WiJzQeAD1FT4xYLgsByEX++GvZDeMDV6czS6UkF4Xtt3BuisX5zwp2yfeehrXpAdAkw==
X-Received: by 2002:a5d:62c8:: with SMTP id o8mr12195838wrv.316.1580479123878;
        Fri, 31 Jan 2020 05:58:43 -0800 (PST)
Received: from localhost (p5df1ee40.dip0.t-ipconnect.de. [93.241.238.64])
        by smtp.gmail.com with ESMTPSA id q3sm10645230wmj.38.2020.01.31.05.58.42
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 05:58:42 -0800 (PST)
Date:   Fri, 31 Jan 2020 14:57:30 +0100
From:   Max Neunhoeffer <max@arangodb.com>
To:     netdev@vger.kernel.org
Subject: epoll_wait misses edge-triggered eventfd events: bug in Linux 5.3
 and 5.4
Message-ID: <20200131135730.ezwtgxddjpuczpwy@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear All,

I believe I have found a bug in Linux 5.3 and 5.4 in epoll_wait/epoll_ctl
when an eventfd together with edge-triggered or the EPOLLONESHOT policy
is used. If an epoll_ctl call to rearm the eventfd happens approximately
at the same time as the epoll_wait goes to sleep, the event can be lost, 
even though proper protection through a mutex is employed.

The details together with two programs showing the problem can be found
here:

  https://bugzilla.kernel.org/show_bug.cgi?id=205933

Older kernels seem not to have this problem, although I did not test all
versions. I know that 4.15 and 5.0 do not show the problem.

Note that this method of using epoll_wait/eventfd is used by
boost::asio to wake up event loops in case a new completion handler
is posted to an io_service, so this is probably relevant for many
applications.

Any help with this would be appreciated.

Cheers,
  Max.
