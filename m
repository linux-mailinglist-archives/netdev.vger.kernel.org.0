Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0402818D100
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 15:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbgCTOfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 10:35:53 -0400
Received: from mga14.intel.com ([192.55.52.115]:18131 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726816AbgCTOfw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 10:35:52 -0400
IronPort-SDR: plrOdcyM16YER5Wi4TT0AuG6MVbp+zgp9Snz9hwFTVOteH/CCnFQpxc8CGb9cESDoTk8VEzHIW
 8uMtNDWB4GNA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 07:35:52 -0700
IronPort-SDR: 31yy+iEliot0MYaUGlxyywSdC2TYVWie+dTp/EwvWI6d5G7CX6cuWYyjHg4ItAZSCUX2kp0+Ge
 tp2Cyown55zQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,284,1580803200"; 
   d="scan'208";a="444986444"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.161])
  by fmsmga005.fm.intel.com with ESMTP; 20 Mar 2020 07:35:48 -0700
Date:   Fri, 20 Mar 2020 16:35:47 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Waiman Long <longman@redhat.com>
Cc:     David Howells <dhowells@redhat.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, Sumit Garg <sumit.garg@linaro.org>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Eric Biggers <ebiggers@google.com>,
        Chris von Recklinghausen <crecklin@redhat.com>
Subject: Re: [PATCH v5 2/2] KEYS: Avoid false positive ENOMEM error on key
 read
Message-ID: <20200320143547.GB3629@linux.intel.com>
References: <20200318221457.1330-1-longman@redhat.com>
 <20200318221457.1330-3-longman@redhat.com>
 <20200319194650.GA24804@linux.intel.com>
 <f22757ad-4d6f-ffd2-eed5-6b9bd1621b10@redhat.com>
 <20200320020717.GC183331@linux.intel.com>
 <7dbc524f-6c16-026a-a372-2e80b40eab30@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7dbc524f-6c16-026a-a372-2e80b40eab30@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 09:27:03AM -0400, Waiman Long wrote:
> On 3/19/20 10:07 PM, Jarkko Sakkinen wrote:
> > On Thu, Mar 19, 2020 at 08:07:55PM -0400, Waiman Long wrote:
> >> On 3/19/20 3:46 PM, Jarkko Sakkinen wrote:
> >>> On Wed, Mar 18, 2020 at 06:14:57PM -0400, Waiman Long wrote:
> >>>> +			 * It is possible, though unlikely, that the key
> >>>> +			 * changes in between the up_read->down_read period.
> >>>> +			 * If the key becomes longer, we will have to
> >>>> +			 * allocate a larger buffer and redo the key read
> >>>> +			 * again.
> >>>> +			 */
> >>>> +			if (!tmpbuf || unlikely(ret > tmpbuflen)) {
> >>> Shouldn't you check that tmpbuflen stays below buflen (why else
> >>> you had made copy of buflen otherwise)?
> >> The check above this thunk:
> >>
> >> if ((ret > 0) && (ret <= buflen)) {
> >>
> >> will make sure that ret will not be larger than buflen. So tmpbuflen > >> will never be bigger than buflen.  > > Ah right, of course, thanks.
> >
> > What would go wrong if the condition was instead
> > ((ret > 0) && (ret <= tmpbuflen))?
> 
> That if statement is a check to see if the actual key length is longer
> than the user-supplied buffer (buflen). If that is the case, it will
> just return the expected length without storing anything into the user
> buffer. For the case that buflen >= ret > tmpbuflen, the revised check
> above will incorrectly skip the storing step causing the caller to
> incorrectly think the key is there in the buffer.
> 
> Maybe I should clarify that a bit more in the comment.

OK, right because it is possible in-between tmpbuflen could be
larger. Got it.

I think that longish key_data and key_data_len would be better
names than tmpbuf and tpmbuflen.

Also the comments are somewat overkill IMHO.

I'd replace them along the lines of

/* Cap the user supplied buffer length to PAGE_SIZE. */

/* Key data can change as we don not hold key->sem. */

/Jarkko
