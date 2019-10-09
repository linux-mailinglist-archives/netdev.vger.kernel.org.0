Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35B5ED079E
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 08:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbfJIGqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 02:46:25 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38186 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfJIGqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 02:46:25 -0400
Received: by mail-lj1-f193.google.com with SMTP id b20so1284281ljj.5
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 23:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netrounds-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=f+gWR+LjmSBbJitTfLQV8AjJIexhV1cxyS84yC8N87o=;
        b=jAmFYcUlczPMa/GIKzBcfOv+GCxavycEJ7t6U88F5+Dt2B4W3JRWnYpnfZi2+8G1bP
         G474GC8PZ+Mmwa3jHuw36I7zhhMQzCDkk6DRlLTYwxsPHU62/BRwJDubtpqA8CdnxLZg
         ZyUdURzQDXEG/2xxyBt/T7HjAFqNZSIw8r7GgIj9XTOidOzLJBwnwRWeznQOdDmtxvxk
         8ch2XqgSmiMqZfF+Nb11PHj+Ws1XmwUD5vtz4S6EaUn3czE2I4QF9Oh/DnYFm6I27RWs
         OGXcaA8nj3bF9/JxpIWR0+BIkcYMK6J8ZGTC9BFrH9bXgafMmcKaPHAy1N6jZzpHGybC
         1k6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=f+gWR+LjmSBbJitTfLQV8AjJIexhV1cxyS84yC8N87o=;
        b=Atx0fI5+D+Xqi/9jJpM5LkHTIC0MnevE4k59JmF6ym4OE5gm0Xjx9FlIyD8KWju932
         8Nq/MepAptPl/kZ1vtu+VeHiAuaGwMUCTKatsqwUVCLPzmv/KpzH7f2N6mxW7xUVIFdM
         RysxP7z0hqBHUfsCzivnA3O7OfO+BpSnOmoxAzgtlhPDSAeyfdOWxYBB9u11KmYnWtT3
         SMp0dDAjaCUGvmSsj1Zsk/wu3s6Xvo048rG2b9syAD/v8B1g7ShwhAxTdTaYl5816R0Q
         H4ICIXhFPVL6QYcjcGScLom1yvpXhQGiTqMffHVqcrX/OJkp+1t4O2arR3KEn5NMGBLQ
         c0VA==
X-Gm-Message-State: APjAAAVUIeQ5Aaehw8T8poeoF/7MfeYNkIM5hS50WciaowYej/tbq4pI
        xGwm5OLqnpGo2CuWexr2vEhAIg==
X-Google-Smtp-Source: APXvYqzMx79MdjNQ10diKOd4OBQPKpH0x6KeOmrH48ZVecxxD63q16fZKrPGZwtGBxkbUM7b6RnDnw==
X-Received: by 2002:a2e:880e:: with SMTP id x14mr1278708ljh.42.1570603583122;
        Tue, 08 Oct 2019 23:46:23 -0700 (PDT)
Received: from [10.0.156.104] ([195.22.87.57])
        by smtp.gmail.com with ESMTPSA id q16sm246677lfp.71.2019.10.08.23.46.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 23:46:22 -0700 (PDT)
From:   Jonas Bonn <jonas.bonn@netrounds.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>, pabeni@redhat.com
Subject: Packet gets stuck in NOLOCK pfifo_fast qdisc
Message-ID: <d102074f-7489-e35a-98cf-e2cad7efd8a2@netrounds.com>
Date:   Wed, 9 Oct 2019 08:46:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The lockless pfifo_fast qdisc has an issue with packets getting stuck in 
the queue.  What appears to happen is:

i)  Thread 1 holds the 'seqlock' on the qdisc and dequeues packets.
ii)  Thread 1 dequeues the last packet in the queue.
iii)  Thread 1 iterates through the qdisc->dequeue function again and 
determines that the queue is empty.

iv)  Thread 2 queues up a packet.  Since 'seqlock' is busy, it just 
assumes the packet will be dequeued by whoever is holding the lock.

v)  Thread 1 releases 'seqlock'.

After v), nobody will check if there are packets in the queue until a 
new packet is enqueued.  Thereby, the packet enqueued by Thread 2 may be 
delayed indefinitely.

What, I think, should probably happen is that Thread 1 should check that 
the queue is empty again after releasing 'seqlock'.  I poked at this, 
but it wasn't obvious to me how to go about this given the way the 
layering works here.  Roughly:

qdisc_run_end() {
...
	spin_unlock(seqlock);
	if (!qdisc_is_empty(qdisc))
		qdisc_run();
...
}

Calling qdisc_run() from qdisc_run_end() doesn't feel right!

There's a qdisc->empty property (and qdisc_is_empty() relies on it) but 
it's not particularly useful in this case since there's a race in 
setting this property which makes it not quite reliable.

Hope someone can shine some light on how to proceed here.

/Jonas
