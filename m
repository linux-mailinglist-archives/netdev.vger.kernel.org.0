Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB1C3FF1EE
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 18:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346533AbhIBQ6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 12:58:32 -0400
Received: from smtp1.emailarray.com ([65.39.216.14]:39176 "EHLO
        smtp1.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346494AbhIBQ6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 12:58:20 -0400
Received: (qmail 20654 invoked by uid 89); 2 Sep 2021 16:57:20 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMQ==) (POLARISLOCAL)  
  by smtp1.emailarray.com with SMTP; 2 Sep 2021 16:57:20 -0000
Date:   Thu, 2 Sep 2021 09:57:19 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, richardcochran@gmail.com,
        netdev@vger.kernel.org, kernel-team@fb.com, abyagowi@fb.com
Subject: Re: [PATCH net-next 08/11] ptp: ocp: Add sysfs attribute
 utc_tai_offset
Message-ID: <20210902165719.4et2m5s7jgrcvac4@bsd-mbp.dhcp.thefacebook.com>
References: <20210830235236.309993-1-jonathan.lemon@gmail.com>
 <20210830235236.309993-9-jonathan.lemon@gmail.com>
 <20210901165642.3fab8ec2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901165642.3fab8ec2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 01, 2021 at 04:56:42PM -0700, Jakub Kicinski wrote:
> On Mon, 30 Aug 2021 16:52:33 -0700 Jonathan Lemon wrote:
> > +static ssize_t
> > +utc_tai_offset_show(struct device *dev,
> > +		    struct device_attribute *attr, char *buf)
> > +{
> > +	struct ptp_ocp *bp = dev_get_drvdata(dev);
> > +
> > +	return sysfs_emit(buf, "%d\n", bp->utc_tai_offset);
> > +}
> > +
> > +static ssize_t
> > +utc_tai_offset_store(struct device *dev,
> > +		     struct device_attribute *attr,
> > +		     const char *buf, size_t count)
> > +{
> > +	struct ptp_ocp *bp = dev_get_drvdata(dev);
> > +	unsigned long flags;
> > +	int err;
> > +	s32 val;
> > +
> > +	err = kstrtos32(buf, 0, &val);
> > +	if (err)
> > +		return err;
> > +
> > +	bp->utc_tai_offset = val;
> 
> This line should probably be under the lock.

Ack.

BTW, I hate this entire function - but don't really 
see a better way to handle it.  One suggestion was 
to automatically get the offset from the NMEA parser,
but I can't depend on GNSS being available.
-- 
Jonathan
