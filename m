Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA7D4D1F62
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 06:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732845AbfJJEPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 00:15:33 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:39700 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732835AbfJJEPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 00:15:32 -0400
Received: by mail-pg1-f174.google.com with SMTP id e1so2800807pgj.6
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 21:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=m0NkuSlIMfpM3r8PPLzZgxOW9nDL98ZvdE8ecs+JICc=;
        b=E0Q/yn6uzmoi2uvuI/wQpwUKKrnS7ZI8uTFZzL72x774TV4BHMF1U2lkgXsKGXrVk8
         DdOjuUVKG9Dfhs/fLjnEokO77f2Aqp5FkYQw8tHCN6HBAMMeLRAyf161EXj7wYF0reya
         WBNyfbdVhVuPMMb1PQAJY8izfGQ/W3QpP7af0L9SnEroFT3Anwy3EQB2VG40yN3XrI6S
         L/a0kpVO8fb3LYLEI0Tvuoj5HKfud2rY8SiZPhnZag9HCdLc2LXzhJZnaHSBlUAkXWgN
         64nlE8VVzqk9lZoDU3cFfMgjp3FMM70YgofYOQ1qm1K+R6htVmLV18EjUdxvaNEZwerK
         8/LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=m0NkuSlIMfpM3r8PPLzZgxOW9nDL98ZvdE8ecs+JICc=;
        b=AomJ+t/MIVnu5RNwSG1HlyrCzfyQKP+LiziWharMG1vOt6+XE8obA4qKzYr75v60Rh
         +gFtT0Yg2HDmH312tBEv1zqUjhv0ctf3881YHz+umHBissDHWJk0/JMHf8b5HXQxFdVk
         q9e4Lk8dk+lPuwr9Uv7VsV0dJFmOjBj3ViSvYwc2dEPYJ7LJUTKclK0kCAXDeO6J60+t
         5LbjrIvpoJ76lrG6oPILM+5TtQ3UyAOYoNuqUavBcGG/pTQ6xbF1BY8Yh9SIol09NtIU
         CK2uYgWBU72eoFeUDAdcXjun5HN1FnbzcY76edL1NJumxcFa4ywaAY8YcYzDFhMwd6o7
         JsuA==
X-Gm-Message-State: APjAAAVF80wswp3nWwECaLyZCNXFR3Cp5+9Lt23WVycsrhxxyr/AsUl5
        jN2u8ZGNkjmuSrBJns87YHY85w==
X-Google-Smtp-Source: APXvYqxvGajdBpRiPRWDdvlNefkdrExKw9aRHCrv8tcsKuNIisr+yI98cqRMbc0hiezPy3UqL0IxlA==
X-Received: by 2002:a63:5ec6:: with SMTP id s189mr8329164pgb.185.1570680930130;
        Wed, 09 Oct 2019 21:15:30 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id s36sm4687632pgk.84.2019.10.09.21.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 21:15:29 -0700 (PDT)
Date:   Wed, 9 Oct 2019 21:15:17 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net
Subject: Re: [PATCHv2 net-next] team: call RCU read lock when walking the
 port_list
Message-ID: <20191009211517.6a66cfa1@cakuba.netronome.com>
In-Reply-To: <20191009121828.25868-1-liuhangbin@gmail.com>
References: <20191008135614.15224-1-liuhangbin@gmail.com>
        <20191009121828.25868-1-liuhangbin@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Oct 2019 20:18:28 +0800, Hangbin Liu wrote:
> Before reading the team port list, we need to acquire the RCU read lock.
> Also change list_for_each_entry() to list_for_each_entry_rcu().
> 
> v2:
> repost the patch to net-next and remove fixes flag as this is a cosmetic
> change.
> 
> Suggested-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> Acked-by: Paolo Abeni <pabeni@redhat.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>

Thank you! Applied
