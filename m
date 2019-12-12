Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0CE11D4EF
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 19:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730257AbfLLSKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 13:10:46 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40919 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730080AbfLLSKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 13:10:46 -0500
Received: by mail-wr1-f67.google.com with SMTP id c14so3762073wrn.7;
        Thu, 12 Dec 2019 10:10:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2FkS+4Qqd9YB/yfl4AmGYyT+drz3UF0FpODz0HkSGMA=;
        b=kMu3mkIB9WF7D/Qb9hukRycItKGl+K1c+5JayfLVoAE2XYyVLHmoWw6XNsuNXC1pGx
         1JbhcA5KJH+PjnjTVkgDbHVhPjgeDC0MF3XO86LNY0OjMANlQMgmPGcN+PnXo3B5T3GI
         5eG6LHPQNAPiHVDagE1mPFDBPyfcOMcnCwiW/elYnCAhOtNjp9Q6ZyDo4V+4hlaeERnr
         57DGST1uhhJ48lLqwzmf+aA3/048QvNRVc+KRQ/qTqEXua1Y5yaXhflYy2m5Im3BDiXg
         nGwldeFnOf0mkf4I+VCs3uEHjvNI9JIhDJFziVsS9C1a9i1ifoWZRWjeYVoNcpWkqSLJ
         0m2g==
X-Gm-Message-State: APjAAAWWoB9qbLaxvdNWU00wtKqYN4s5iXAACPhl8kwO9fULLyaxkDh0
        jOEEy/qslg5q3/rf58GsW5E=
X-Google-Smtp-Source: APXvYqw/uME6tOeL7OUNHpp0730NBNHkdBcAqsk97DSNHM6GFRhnhLP9/9ujUjhyVbAVN3av+4I7DA==
X-Received: by 2002:a5d:4d0e:: with SMTP id z14mr7540381wrt.208.1576174243640;
        Thu, 12 Dec 2019 10:10:43 -0800 (PST)
Received: from debian (122.163.200.146.dyn.plus.net. [146.200.163.122])
        by smtp.gmail.com with ESMTPSA id n189sm6278387wme.33.2019.12.12.10.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 10:10:43 -0800 (PST)
Date:   Thu, 12 Dec 2019 18:10:41 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Paul Durrant <pdurrant@amazon.com>
Cc:     netdev@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] xen-netback: avoid race that can lead to NULL
 pointer dereference
Message-ID: <20191212181041.mjuoy4el6h2jedhv@debian>
References: <20191212123723.21548-1-pdurrant@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212123723.21548-1-pdurrant@amazon.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 12:37:23PM +0000, Paul Durrant wrote:
> Commit 2ac061ce97f4 ("xen/netback: cleanup init and deinit code")
> introduced a problem. In function xenvif_disconnect_queue(), the value of
> queue->rx_irq is zeroed *before* queue->task is stopped. Unfortunately that
> task may call notify_remote_via_irq(queue->rx_irq) and calling that
> function with a zero value results in a NULL pointer dereference in
> evtchn_from_irq().
> 
> This patch simply re-orders things, stopping all tasks before zero-ing the
> irq values, thereby avoiding the possibility of the race.
> 
> Signed-off-by: Paul Durrant <pdurrant@amazon.com>

Acked-by: Wei Liu <wei.liu@kernel.org>
