Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E50924A8D4
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 00:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbgHSWAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 18:00:15 -0400
Received: from wildebeest.demon.nl ([212.238.236.112]:53276 "EHLO
        gnu.wildebeest.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbgHSWAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 18:00:12 -0400
Received: from tarox.wildebeest.org (tarox.wildebeest.org [172.31.17.39])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by gnu.wildebeest.org (Postfix) with ESMTPSA id D94B4300D92B;
        Thu, 20 Aug 2020 00:00:09 +0200 (CEST)
Received: by tarox.wildebeest.org (Postfix, from userid 1000)
        id BEF6E413CE8D; Thu, 20 Aug 2020 00:00:09 +0200 (CEST)
Message-ID: <f03e0fec4b29afe24a7a13c43de23e6db6dfce23.camel@klomp.org>
Subject: Re: Kernel build error on BTFIDS vmlinux
From:   Mark Wielaard <mark@klomp.org>
To:     Jiri Olsa <jolsa@redhat.com>, Nick Clifton <nickc@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>, sdf@google.com,
        andriin@fb.com
Date:   Thu, 20 Aug 2020 00:00:09 +0200
In-Reply-To: <20200819171820.GG177896@krava>
References: <20200818105555.51fc6d62@carbon> <20200818091404.GB177896@krava>
         <20200818105602.GC177896@krava> <20200818134543.GD177896@krava>
         <20200818183318.2c3fe4a2@carbon>
         <c9c4a42ba6b4d36e557a5441e90f7f4961ec3f72.camel@klomp.org>
         <0ddf7bc5-be05-cc06-05d7-2778c53d023b@redhat.com>
         <20200819171820.GG177896@krava>
Content-Type: multipart/mixed; boundary="=-zSplKr7l+VSXfgLRPXF8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
X-Spam-Flag: NO
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.0
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on gnu.wildebeest.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-zSplKr7l+VSXfgLRPXF8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 2020-08-19 at 19:18 +0200, Jiri Olsa wrote:
> On Wed, Aug 19, 2020 at 04:34:30PM +0100, Nick Clifton wrote:
> > > So it would be nice if binutils ld could also be fixed to write out
> > > compressed sections with the correct alignment.
> >=20
> > OK, I will look into doing this.
> >=20
> > By any chance is there a small test case that you are using to check
> > this behaviour ?   If so, please may I have a copy for myself ?
>=20
> so when I take empty object and compile like:
>=20
>   $ echo 'int main(int argc, char **argv) { return 0; }' | gcc -c -o ex.o=
 -g -gz=3Dzlib -x c -
>   $ ld -o ex --compress-debug-sections=3Dzlib ex.o
>=20
> then there's .debug_info section that shows sh_addralign =3D 1

Specifically, if you extend the example code a bit so that it has a
couple more interesting compressed .debug sections (like in an vmlinux
image) you'll see, eu-readelf -Sz:

Section Headers:
[Nr] Name                 Type         Addr             Off      Size     E=
S Flags Lk Inf Al
     [Compression  Size     Al]

[37] .debug_aranges       PROGBITS     0000000000000000 027ae9f0 0000b274  =
0 C      0   0 16
     [ELF ZLIB (1) 00028030 16]
[38] .debug_info          PROGBITS     0000000000000000 027b9c64 07b1fc3d  =
0 C      0   0  1
     [ELF ZLIB (1) 0cb137ad  1]
[39] .debug_abbrev        PROGBITS     0000000000000000 0a2d98a1 00119647  =
0 C      0   0  1
     [ELF ZLIB (1) 0060811f  1]
[40] .debug_line          PROGBITS     0000000000000000 0a3f2ee8 007086ba  =
0 C      0   0  1
     [ELF ZLIB (1) 01557659  1]
[41] .debug_frame         PROGBITS     0000000000000000 0aafb5a8 000ab7ff  =
0 C      0   0  8
     [ELF ZLIB (1) 002a6bf8  8]
[42] .debug_str           PROGBITS     0000000000000000 0aba6da7 000f86e3  =
1 MSC    0   0  1
     [ELF ZLIB (1) 003a8a8e  1]
[43] .debug_loc           PROGBITS     0000000000000000 0ac9f48a 002e12bd  =
0 C      0   0  1
     [ELF ZLIB (1) 00e0c448  1]
[44] .debug_ranges        PROGBITS     0000000000000000 0af80750 001a9ec7  =
0 C      0   0 16
     [ELF ZLIB (1) 00e84b20 16]

Note that the sh_addralign of the sections is set to the same valie as
ch_addralign. That is the alignment of the decompressed data, what
sh_addralign would have been if it wasn't a compressed section.

The sh_addralign of a compressed section however should be equal to
alignment for the datastructure inside it, either 4, for 32bit:

typedef struct
{
  Elf32_Word    ch_type;        /* Compression format.  */
  Elf32_Word    ch_size;        /* Uncompressed data size.  */
  Elf32_Word    ch_addralign;   /* Uncompressed data alignment.  */
} Elf32_Chdr;

or 8, for 64bit:

typedef struct
{
  Elf64_Word    ch_type;        /* Compression format.  */
  Elf64_Word    ch_reserved;
  Elf64_Xword   ch_size;        /* Uncompressed data size.  */
  Elf64_Xword   ch_addralign;   /* Uncompressed data alignment.  */
} Elf64_Chdr;

At least, that is what elfutils libelf expects. And which I believe is
what the ELF spec implies when it says:

   The sh_size and sh_addralign fields of the section header for a
   compressed section reflect the requirements of the compressed
   section.  The ch_size and ch_addralign fields in the compression
   header provide the corresponding values for the uncompressed data,
   thereby supplying the values that sh_size and sh_addralign would
   have had if the section had not been compressed.

> after I open the 'ex' obejct with elf_begin and iterate sections
>=20
> according to Mark that should be 8 (on 64 bits)
>=20
> when I change it to 8, the elf_update call won't fail for me
> on that elf file

Right, I have a patch that fixes it up in libelf, see attached.
That should make things work without needing a workaround. But of
course I just posted it and it isn't even upstream yet. So for now the
workaround will be needed and it would be nice if binutils ld could
also be fixed to set the sh_addralign field correctly.

Cheers,

Mark

--=-zSplKr7l+VSXfgLRPXF8
Content-Disposition: attachment;
	filename*0=0001-libelf-Fixup-SHF_COMPRESSED-sh_addralign-in-elf_upda.pat;
	filename*1=ch
Content-Type: text/x-patch;
	name="0001-libelf-Fixup-SHF_COMPRESSED-sh_addralign-in-elf_upda.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbSA1NWM1YzlhNTY4ZWQ3MDdiY2VhMTM4OGJmM2E1MjUyMTJkOGNmNGI4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXJrIFdpZWxhYXJkIDxtYXJrQGtsb21wLm9yZz4KRGF0ZTog
V2VkLCAxOSBBdWcgMjAyMCAyMzo0MToyNCArMDIwMApTdWJqZWN0OiBbUEFUQ0hdIGxpYmVsZjog
Rml4dXAgU0hGX0NPTVBSRVNTRUQgc2hfYWRkcmFsaWduIGluIGVsZl91cGRhdGUgaWYKIG5lY2Vz
c2FyeS4KCkluIGVsZl9nZXRkYXRhLmMgd2UgaGF2ZSB0aGUgZm9sbG93aW5nIHRvIGNvbXBlbnNh
dGUgZm9yIHBvc3NpYmx5CmJhZCBzaF9hZGRyYWxpZ24gdmFsdWVzIG9mIGNvbXByZXNzZWQgc2Vj
dGlvbnM6CgogICAgICAvKiBDb21wcmVzc2VkIGRhdGEgaGFzIGEgaGVhZGVyLCBidXQgdGhlbiBj
b21wcmVzc2VkIGRhdGEuCiAgICAgICAgIE1ha2Ugc3VyZSB0byBzZXQgdGhlIGFsaWdubWVudCBv
ZiB0aGUgaGVhZGVyIGV4cGxpY2l0bHksCiAgICAgICAgIGRvbid0IHRydXN0IHRoZSBmaWxlIGFs
aWdubWVudCBmb3IgdGhlIHNlY3Rpb24sIGl0IGlzCiAgICAgICAgIG9mdGVuIHdyb25nLiAgKi8K
ICAgICAgaWYgKChmbGFncyAmIFNIRl9DT01QUkVTU0VEKSAhPSAwKQogICAgICAgIHsKICAgICAg
ICAgIGVudHNpemUgPSAxOwogICAgICAgICAgYWxpZ24gPSBfX2xpYmVsZl90eXBlX2FsaWduIChl
bGYtPmNsYXNzLCBFTEZfVF9DSERSKTsKICAgICAgICB9CgpXaGljaCBtYWtlcyBzdXJlIHRoZSBk
X2RhdGEgYWxpZ25tZW50IGlzIGNvcnJlY3QgZm9yIHRoZSBDaGRyIHN0cnVjdAphdCB0aGUgc3Rh
cnQgb2YgdGhlIGNvbXByZXNzZWQgc2VjdGlvbi4KCkJ1dCB0aGlzIG1lYW5zIHRoYXQgaWYgYSB1
c2VyIGp1c3QgcmVhZHMgc3VjaCBhIGNvbXByZXNzZWQgc2VjdGlvbgp3aXRob3V0IGNoYW5naW5n
IGl0LCBhbmQgdGhlbiB0cmllcyB0byB3cml0ZSBpdCBvdXQgYWdhaW4gdXNpbmcKZWxmX3VwZGF0
ZSB0aGV5IGdldCBhbiBlcnJvciBtZXNzYWdlIGFib3V0IGRfYWxpZ24gYW5kIHNoX2FkZHJhbGln
bgpiZWluZyBvdXQgb2Ygc3luYy4KCldlIGFscmVhZHkgY29ycmVjdCBvYnZpb3VzbHkgaW5jb3Jy
ZWN0IHNoX2VudHNpemUgZmllbGRzLgpEbyB0aGUgc2FtZSBmb3IgdGhlIHNoX2FkZHJhbGlnbiBm
aWVsZCBvZiBhIFNIRl9DT01QUkVTU0VEIHNlY3Rpb24uCgpTaWduZWQtb2ZmLWJ5OiBNYXJrIFdp
ZWxhYXJkIDxtYXJrQGtsb21wLm9yZz4KLS0tCiBsaWJlbGYvQ2hhbmdlTG9nICAgICAgICAgIHwg
IDUgKysrKysKIGxpYmVsZi9lbGYzMl91cGRhdGVudWxsLmMgfCAxMiArKysrKysrKysrKysKIDIg
ZmlsZXMgY2hhbmdlZCwgMTcgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2xpYmVsZi9DaGFu
Z2VMb2cgYi9saWJlbGYvQ2hhbmdlTG9nCmluZGV4IDhmNmQyZDJkLi43NzA0NGMxYyAxMDA2NDQK
LS0tIGEvbGliZWxmL0NoYW5nZUxvZworKysgYi9saWJlbGYvQ2hhbmdlTG9nCkBAIC0xLDMgKzEs
OCBAQAorMjAyMC0wOC0xOSAgTWFyayBXaWVsYWFyZCAgPG1hcmtAa2xvbXAub3JnPgorCisJKiBl
bGYzMl91cGRhdGVudWxsLmMgKHVwZGF0ZW51bGxfd3Jsb2NrKTogRml4dXAgdGhlIHNoX2FkZHJh
bGlnbgorCW9mIGFuIFNIRl9DT01QUkVTU0VEIHNlY3Rpb24gaWYgbmVjZXNzYXJ5LgorCiAyMDIw
LTA2LTA0ICBNYXJrIFdpZWxhYXJkICA8bWFya0BrbG9tcC5vcmc+CiAKIAkqIGVsZi5oOiBVcGRh
dGUgZnJvbSBnbGliYy4KZGlmZiAtLWdpdCBhL2xpYmVsZi9lbGYzMl91cGRhdGVudWxsLmMgYi9s
aWJlbGYvZWxmMzJfdXBkYXRlbnVsbC5jCmluZGV4IDVmM2NkYmY2Li5kMGQ0ZDFlYiAxMDA2NDQK
LS0tIGEvbGliZWxmL2VsZjMyX3VwZGF0ZW51bGwuYworKysgYi9saWJlbGYvZWxmMzJfdXBkYXRl
bnVsbC5jCkBAIC0yNjcsNiArMjY3LDE4IEBAIF9fZWxmdzIoTElCRUxGQklUUyx1cGRhdGVudWxs
X3dybG9jaykgKEVsZiAqZWxmLCBpbnQgKmNoYW5nZV9ib3AsIHNpemVfdCBzaG51bSkKIAkgICAg
ICB1cGRhdGVfaWZfY2hhbmdlZCAoc2hkci0+c2hfZW50c2l6ZSwgc2hfZW50c2l6ZSwKIAkJCQkg
c2NuLT5zaGRyX2ZsYWdzKTsKIAorCSAgICAgIC8qIExpa2V3aXNlIGZvciB0aGUgYWxpZ25tZW50
IG9mIGEgY29tcHJlc3NlZCBzZWN0aW9uLgorCSAgICAgICAgIEZvciBhIFNIRl9DT01QUkVTU0VE
IHNlY3Rpb24gc2V0IHRoZSBjb3JyZWN0CisJICAgICAgICAgc2hfYWRkcmFsaWduIHZhbHVlLCB3
aGljaCBtdXN0IG1hdGNoIHRoZSBkX2FsaWduIG9mCisJICAgICAgICAgdGhlIGRhdGEgKHNlZSBf
X2xpYmVsZl9zZXRfcmF3ZGF0YSBpbiBlbGZfZ2V0ZGF0YS5jKS4gICovCisJICAgICAgaWYgKChz
aGRyLT5zaF9mbGFncyAmIFNIRl9DT01QUkVTU0VEKSAhPSAwKQorCQl7CisJCSAgc2hfYWxpZ24g
PSBfX2xpYmVsZl90eXBlX2FsaWduIChFTEZXKEVMRkNMQVNTLExJQkVMRkJJVFMpLAorCQkJCQkJ
ICBFTEZfVF9DSERSKTsKKwkJICB1cGRhdGVfaWZfY2hhbmdlZCAoc2hkci0+c2hfYWRkcmFsaWdu
LCBzaF9hbGlnbiwKKwkJCQkgICAgIHNjbi0+c2hkcl9mbGFncyk7CisJCX0KKwogCSAgICAgIGlm
IChzY24tPmRhdGFfcmVhZCA9PSAwCiAJCSAgJiYgX19saWJlbGZfc2V0X3Jhd2RhdGFfd3Jsb2Nr
IChzY24pICE9IDApCiAJCS8qIFNvbWV0aGluZyB3ZW50IHdyb25nLiAgVGhlIGVycm9yIHZhbHVl
IGlzIGFscmVhZHkgc2V0LiAgKi8KLS0gCjIuMTguNAoK


--=-zSplKr7l+VSXfgLRPXF8--
