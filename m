Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D64635DCCA
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 12:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343970AbhDMKto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 06:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343891AbhDMKsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 06:48:47 -0400
Received: from blyat.fensystems.co.uk (blyat.fensystems.co.uk [IPv6:2a05:d018:a4d:6403:2dda:8093:274f:d185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45877C061574
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 03:48:25 -0700 (PDT)
Received: from dolphin.home (unknown [IPv6:2a00:23c6:5495:5e00:72b3:d5ff:feb1:e101])
        by blyat.fensystems.co.uk (Postfix) with ESMTPSA id 7678944263;
        Tue, 13 Apr 2021 10:48:21 +0000 (UTC)
Subject: Re: xen-netback hotplug-status regression bug
To:     paul@xen.org, Wei Liu <wei.liu@kernel.org>,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        Paul Durrant <pdurrant@amazon.com>
References: <afedd7cb-a291-e773-8b0d-4db9b291fa98@ipxe.org>
 <f469cdee-f97e-da3f-bcab-0be9ed8cd836@xen.org>
From:   Michael Brown <mcb30@ipxe.org>
Message-ID: <58ccc3b7-9ccb-b9bf-84e7-4a023ccb5c56@ipxe.org>
Date:   Tue, 13 Apr 2021 11:48:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <f469cdee-f97e-da3f-bcab-0be9ed8cd836@xen.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on
        blyat.fensystems.co.uk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/04/2021 08:12, Paul Durrant wrote:
>> If the frontend subsequently disconnects and reconnects (e.g. 
>> transitions through Closed->Initialising->Connected) then:
>>
>> - Nothing recreates "hotplug-status"
>>
>> - When the frontend re-enters Connected state, connect() sets up a 
>> watch on "hotplug-status" again
>>
>> - The callback hotplug_status_changed() is never triggered, and so the 
>> backend device never transitions to Connected state.
> 
> That's not how I read it. Given that "hotplug-status" is removed by the 
> call to hotplug_status_changed() then the next call to connect() should 
> fail to register the watch and 'have_hotplug_status_watch' should be 0. 
> Thus backend_switch_state() should not defer the transition to 
> XenbusStateConnected in any subsequent interaction with the frontend.

Thank you for the reply.  I've tested and confirmed my initial 
hypothesis: the call to xenbus_watch_pathfmt() succeeds even if the node 
does not exist.

I confirmed this with ftrace using:

   cd /sys/kernel/debug/tracing
   echo function_graph > current_tracer
   echo set_backend_state > set_ftrace_filter
   echo xenbus_watch_pathfmt >> set_ftrace_filter
   echo register_xenbus_watch >> set_ftrace_filter
   echo xenbus_dev_fatal >> set_ftrace_filter

On the second time that the frontend transitions to Connected, this 
produced the trace:

   set_backend_state [xen_netback]() {
     register_xenbus_watch();
     register_xenbus_watch();
     xenbus_watch_pathfmt() {
       register_xenbus_watch();
     }
   }

which seems to confirm that the error path in xenbus_watch_path() is 
*not* taken, i.e. that the call to register_xenbus_watch() succeeded 
even though the node did not exist.


Other observations also seem to confirm this behaviour:

- Running "xenstore ls" in dom0 confirms that on the second frontend 
transition to Connected, the frontend state is indeed Connected (4) but 
the backend state remains in InitWait (2)

- Running "xenstore watch 
/local/domain/0/backend/vif/<domU>/0/hotplug-status" *before* starting 
the domU confirms that it is possible to create a watch on a node that 
does not (yet) exist, and that the watch *is* notified when the node is 
later created.

> Are you seeing the watch successfully re-registered even though the node 
> does not exist? Perhaps there has been a change in xenstore behaviour?

So, the TL;DR is that yes, the watch does successfully register even 
though the node does not exist.

 From a quick look through the xenstored source, it looks as though the 
only check on the node name is the call to is_valid_nodename(), which 
seems to perform a syntactic validity check only.  I can't immediately 
find any commit that would have changed this behaviour.

Thanks,

Michael
