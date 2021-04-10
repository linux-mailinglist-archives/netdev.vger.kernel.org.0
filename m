Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 429AF35AF9A
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 20:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234889AbhDJScF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Apr 2021 14:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234851AbhDJScE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Apr 2021 14:32:04 -0400
X-Greylist: delayed 401 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 10 Apr 2021 11:31:49 PDT
Received: from blyat.fensystems.co.uk (blyat.fensystems.co.uk [IPv6:2a05:d018:a4d:6403:2dda:8093:274f:d185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B9DC06138A
        for <netdev@vger.kernel.org>; Sat, 10 Apr 2021 11:31:49 -0700 (PDT)
Received: from dolphin.home (unknown [IPv6:2a00:23c6:5495:5e00:72b3:d5ff:feb1:e101])
        by blyat.fensystems.co.uk (Postfix) with ESMTPSA id 3DBA24422B;
        Sat, 10 Apr 2021 18:25:04 +0000 (UTC)
To:     Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        Paul Durrant <pdurrant@amazon.com>
From:   Michael Brown <mcb30@ipxe.org>
Subject: xen-netback hotplug-status regression bug
Message-ID: <afedd7cb-a291-e773-8b0d-4db9b291fa98@ipxe.org>
Date:   Sat, 10 Apr 2021 19:25:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
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

Commit https://github.com/torvalds/linux/commit/1f25657 ("xen-netback: 
remove 'hotplug-status' once it has served its purpose") seems to have 
introduced a regression that prevents a vif frontend from transitioning 
more than once into Connected state.

As far as I can tell:

- The defined vif script (e.g. /etc/xen/scripts/vif-bridge) executes 
only once, at domU startup, and sets 
backend/vif/<domU>/0/hotplug-status="connected"

- When the frontend first enters Connected state, 
drivers/net/xen-netback/xenbus.c's connect() sets up a watch on 
"hotplug-status" with the callback function hotplug_status_changed()

- When hotplug_status_changed() is triggered by the watch, it 
transitions the backend to Connected state and calls xenbus_rm() to 
delete the "hotplug-status" attribute.

If the frontend subsequently disconnects and reconnects (e.g. 
transitions through Closed->Initialising->Connected) then:

- Nothing recreates "hotplug-status"

- When the frontend re-enters Connected state, connect() sets up a watch 
on "hotplug-status" again

- The callback hotplug_status_changed() is never triggered, and so the 
backend device never transitions to Connected state.


Reverting the commit would fix this bug, but would obviously also 
reintroduce the race condition that the commit was designed to avoid.

I'm happy to put together a patch, if one of the maintainers could 
suggest a sensible design approach.

I'm not a list member, so please CC me directly on replies.

Thanks,

Michael
