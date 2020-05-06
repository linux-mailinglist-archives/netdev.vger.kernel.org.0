Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545631C6AEB
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 10:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728616AbgEFIIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 04:08:37 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:31557 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728605AbgEFIIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 04:08:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588752513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=CBWxp/RqrAZHRhIdtBhb3xri0XLzwh+Ch7QU+ftNF34=;
        b=X5aij9Dcg2c93UiXjCx3F/VgGLUlK7pOUCYpH/bYM3QYiDkBSGh0H+oceIGQiF7O03vaEV
        tAM8Jk8uRuPne4OoGVMRylpzKyTsqwfgTWG3njDnYngWMNqaZ2x5ZG5UaL+8YXkyqaIw5v
        GGwZCsCSe+cvN9YtNFcYgdbqxo+4S5M=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-cAjZpfPUM6Sff_igWw0p0Q-1; Wed, 06 May 2020 04:08:32 -0400
X-MC-Unique: cAjZpfPUM6Sff_igWw0p0Q-1
Received: by mail-wm1-f71.google.com with SMTP id h6so793102wmi.7
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 01:08:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=CBWxp/RqrAZHRhIdtBhb3xri0XLzwh+Ch7QU+ftNF34=;
        b=NGERMH2mWACkmtEhXZdx7nYGIbemSAmzft7GYFMquVlOb8i+Bwgneu6l5aHOErk3GP
         OPPCEGgtx7HFgyDYIOxEzMrCh1XwWhQSQqQXyH1KdYaRk5WHKuq+EKfAPtfvYeuVFi0u
         ykvKaPRxWmJat//WL4Kn3qTmoFYXeQbmnzrt20aeDpZRCxXINe6V7RNgfvZDLHy795t+
         RV9cSR6KktdMu7WQxfIsHqqiuYMEoEYXGKMs+ApoDRB29kvgJWD/Dw1kKvH+WcKt/sYi
         HsDPh9vQGxD84LX4AG2eosp1b9q9/1bKTBI6dSBYL3rhRK/er8BJpzpNBU/JkDoBnwg1
         dpPA==
X-Gm-Message-State: AGi0PuZJi826QNJOsyLa1vdlYQ5rXd29gmgdDQDrmI9xE2ygMpRt7jv6
        1984uv0HWYsNL4IRITqlGRgOyv7Y+qVZcImhbCB/1KeBeb8Qc99KNRDYU+5val3OazLchx/Dt8q
        MRqrTj3N7gX3mjHnR
X-Received: by 2002:a5d:54c4:: with SMTP id x4mr8713633wrv.73.1588752511065;
        Wed, 06 May 2020 01:08:31 -0700 (PDT)
X-Google-Smtp-Source: APiQypKoYFzRFdcs5OUqDOntDuXyJrKD5k/C6ihqMqcjU/DctdS4/KReL94LfbKFGzcZw7Aen1K6xw==
X-Received: by 2002:a5d:54c4:: with SMTP id x4mr8713617wrv.73.1588752510881;
        Wed, 06 May 2020 01:08:30 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id g25sm1724902wmh.24.2020.05.06.01.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 01:08:30 -0700 (PDT)
Date:   Wed, 6 May 2020 04:08:27 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eugenio Perez Martin <eperezma@redhat.com>
Subject: performance bug in virtio net xdp
Message-ID: <20200506035704-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So for mergeable bufs, we use ewma machinery to guess the correct buffer
size. If we don't guess correctly, XDP has to do aggressive copies.

Problem is, xdp paths do not update the ewma at all, except
sometimes with XDP_PASS. So whatever we happen to have
before we attach XDP, will mostly stay around.

The fix is probably to update ewma unconditionally.

-- 
MST

