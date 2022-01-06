Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9481448667C
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 16:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240375AbiAFPG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 10:06:28 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.48]:33638 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240374AbiAFPG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 10:06:27 -0500
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Jan 2022 10:06:27 EST
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 16F0C2256ED
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 15:00:03 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.67.123])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id BCB071C0081
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 14:59:59 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 9C3344C0085
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 14:59:59 +0000 (UTC)
Received: from [192.168.1.115] (unknown [98.97.67.209])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 2158413C2B0
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 06:59:59 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 2158413C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1641481199;
        bh=kHd49JrJo5BehITeLZZV7KOXs+hDBBfq0FD+SaCnMz8=;
        h=To:From:Subject:Date:From;
        b=GU4yOlEmINnuFy+gZ4maDQVunMQ5GgiC/q1pKedip9SfNER8+MS20dNQEwNFkhm/b
         DUyiex4RTzH9eel3xiBI3c4+rx4nj5qOaQBXhCyR76qRGV6hBYY37NLIk/DWlBp3Lt
         TxvOjXxb+fb5x2VBSRjn4ar1237fF2C7fmqBZDU8=
To:     netdev <netdev@vger.kernel.org>
From:   Ben Greear <greearb@candelatech.com>
Subject: Debugging stuck tcp connection across localhost
Organization: Candela Technologies
Message-ID: <38e55776-857d-1b51-3558-d788cf3c1524@candelatech.com>
Date:   Thu, 6 Jan 2022 06:59:58 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
X-MDID: 1641481200-aDqK0tVtjta0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I'm working on a strange problem, and could use some help if anyone has ideas.

On a heavily loaded system (500+ wifi station devices, VRF device per 'real' netdev,
traffic generation on the netdevs, etc), I see cases where two processes trying
to communicate across localhost with TCP seem to get a stuck network
connection:

[greearb@bendt7 ben_debug]$ grep 4004 netstat.txt |grep 127.0.0.1
tcp        0 7988926 127.0.0.1:4004          127.0.0.1:23184         ESTABLISHED
tcp        0  59805 127.0.0.1:23184         127.0.0.1:4004          ESTABLISHED

Both processes in question continue to execute, and as far as I can tell, they are properly
attempting to read/write the socket, but they are reading/writing 0 bytes (these sockets
are non blocking).  If one was stuck not reading, I would expect netstat
to show bytes in the rcv buffer, but it is zero as you can see above.

Kernel is 5.15.7+ local hacks.  I can only reproduce this in a big messy complicated
test case, with my local ath10k-ct and other patches that enable virtual wifi stations,
but my code can grab logs at time it sees the problem.  Is there anything
more I can do to figure out why the TCP connection appears to be stuck?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
